#!/bin/bash
        # Soubor pro uložení úkolů
        
TODO_FILE="$HOME/ukolovnik/.todo_list.txt"
LOG_FILE="$HOME/ukolovnik/.todo_history.log"

        # Vytvoření souboru, pokud neexistuje
        
if [ ! -f "$TODO_FILE" ];
then
    touch "$TODO_FILE"
fi

        # Vytvoření log souboru, pokud neexistuje
        
if [ ! -f "$LOG_FILE" ];
then
    touch "$LOG_FILE"
fi

        # Pokusí se načíst barvyTextu.sh
        
if [ -f "./barvyTextu.sh" ];
then
    source ./barvyTextu.sh
    
else
    echo " CHYBA nenalezen soubor : barvyTextu.sh "
    echo " Texty budou monochromatické"
fi

        # Funkce pro logování akcí
        
log_action() {
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo "[$timestamp] $1" >> "$LOG_FILE"
}

        # Funkce pro zobrazení nápovědy
        
show_help() {
    echo""
    echo "=== SEZNAM ÚKOLŮ ==="
    echo ""
    echo "Použití: $0 [příkaz]"
    echo ""
    echo "Volby:"
    echo "  add \"text\"      - Přidat nový úkol (text vždy do uvozovek)"
    echo "  list            - Zobrazit všechny úkoly"
    echo "  done [číslo]    - Označit úkol jako splněný"
    echo "  delete [číslo]  - Smazat úkol"
    echo "  clear           - Smazat všechny úkoly"
    echo "  history         - Zobrazit historii operací"
    echo "  help            - Zobrazit tuto nápovědu"
}

        # Funkce pro přidání úkolu
        
add_task() {
    if [ -z "$1" ];
    then
        echo -e "${RED} Chyba: Musíte zadat text úkolu ${RESET}"
        echo -e "${CYEN} Příklad: $0 add \"Nakoupit mléko\" ${RESET}"
        exit 1
    fi
    echo "[ ] $1" >> "$TODO_FILE"
    echo -e "${CYEN} ✓ Úkol přidán:${RESET} $1"
    log_action "PŘIDÁNO: $1"
}

        # Funkce pro zobrazení seznamu

list_tasks() {
    if [ ! -s "$TODO_FILE" ];
    then
       echo -e "${CYEN} Seznam úkolů je prázdný. ${RESET}"
        return
    fi
    echo -e "${GREEN} === SEZNAM ÚKOLŮ === ${RESET}"
    local i=1
    while IFS= read -r line; do
        echo "$i. $line"
        ((i++))
    done < "$TODO_FILE"
}

        # Funkce pro označení úkolu jako splněného

mark_done() {
    if [ -z "$1" ];
    then
        echo -e "${RED} Chyba: Musíte zadat číslo úkolu ${RESET}"
        exit 1
    fi
    local line_count=$(wc -l < "$TODO_FILE")
    if [ "$1" -gt "$line_count" ] || [ "$1" -lt 1 ]; then
        echo -e "${RED} Chyba: Neplatné číslo úkolu ${RESET}"
        exit 1
    fi
    local task=$(sed -n "${1}p" "$TODO_FILE")
    local done_task=$(echo "$task" | sed 's/\[ \]/[X]/')
    sed -i "${1}s/.*/$done_task/" "$TODO_FILE"
    echo -e "${CYEN} ✓ Úkol označen jako splněný ${RESET}"
    log_action "SPLNĚNO: $task"
}

        # Funkce pro smazání úkolu
        
delete_task() {
    if [ -z "$1" ];
    then
        echo -e "${RED} Chyba: Musíte zadat číslo úkolu ${RESET}"
        exit 1
    fi
    local line_count=$(wc -l < "$TODO_FILE")
    if [ "$1" -gt "$line_count" ] || [ "$1" -lt 1 ]; then
       echo -e "${RED} Chyba: Neplatné číslo úkolu ${RESET}"
        exit 1
    fi
    local task=$(sed -n "${1}p" "$TODO_FILE")
    sed -i "${1}d" "$TODO_FILE"
    echo -e "${CYEN} ✓ Úkol smazán ${RESET}"
    log_action "SMAZÁNO: $task"
}

        # Funkce pro smazání všech úkolů
        
clear_all() {
    read -p "$(echo -e '\033[38;5;220mOpravdu chcete smazat všechny úkoly? (ano/ne):\033[0m ')" confirm
    if [ "$confirm" = "ano" ];
    then
        local count=$(wc -l < "$TODO_FILE")
        > "$TODO_FILE"
        echo -e "${CYEN} ✓ Všechny úkoly smazány ${RESET}"
        log_action "VYMAZÁNO VŠECHNO: $count úkolů"
    else
        echo -e "${CYEN} Operace zrušena ${RESET}"
    fi
}

        # Funkce pro zobrazení historie
        
show_history() {
    if [ ! -s "$LOG_FILE" ];
    then
        echo -e "${CYEN} Historie je prázdná ${RESET}"
        return
    fi
    echo -e "${GREEN} === HISTORIE OPERACÍ ===${RESET}"
    cat "$LOG_FILE"
}

        # Hlavní funkčnost programu
        
case "$1" in
    add)
        add_task "$2"
        ;;
    list|"")
        list_tasks
        ;;
    done)
        mark_done "$2"
        ;;
    delete)
        delete_task "$2"
        ;;
    clear)
        clear_all
        ;;
    history)
        show_history
        ;;
    help|--help|-h)
        show_help
        ;;
    *)
        echo -e "${RED}Neznámý příkaz: $1 ${RESET}"
        show_help
        exit 1
        ;;
esac
