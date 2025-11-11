#!/bin/bash
       
      
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
    echo -e "${GREEN} ======================================= SEZNAM ÚKOLŮ ======================================= ${RESET}"
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

      # Funkce pro zobrazení nápovědy
        
show_help() {
    echo -e "${YELLOW} ======================================= HELP ======================================= "${RESET}"
    echo -e "${GREEN}  ==================================== SEZNAM ÚKOLŮ ================================== "${RESET}"
    echo -e "Použití: $0 [${YELLOW}příkaz${RESET}]"
    echo "=========="
    echo -e "${YELLOW} Příkazy: ${RESET}"
    echo "=========="
    echo -e "${YELLOW}  add ${RESET}\"text\"      - Přidat nový úkol (celý text úkolu vždy do uvozovek)"
    echo -e "${YELLOW}  list ${RESET}           - Zobrazit všechny úkoly"
    echo -e "${YELLOW}  done ${RESET}[číslo]    - Označit úkol jako splněný"
    echo -e "${YELLOW}  delete ${RESET}[číslo]  - Smazat úkol"
    echo -e "${YELLOW}  clear ${RESET}          - Smazat všechny úkoly"
    echo -e "${YELLOW}  history ${RESET}        - Zobrazit historii operací"
    echo -e "${YELLOW}  help ${RESET}           - Zobrazit tuto nápovědu"
    echo " ======================================= HELP ======================================= "   
    
}



         # Funkce pro logování akcí
        
log_action() {
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo "[$timestamp] $1" >> "$LOG_FILE"
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
        
