#!/bin/bash

# Soubor pro uložení úkolů
TODO_FILE="$HOME/.todo_list.txt"

# Vytvoření souboru, pokud neexistuje
if [ ! -f "$TODO_FILE" ]; then
    touch "$TODO_FILE"
fi

# Funkce pro zobrazení nápovědy
show_help() {
    echo "=== TODO LIST ==="
    echo "Použití: $0 [volba]"
    echo ""
    echo "Volby:"
    echo "  add \"text\"       - Přidat nový úkol"
    echo "  list            - Zobrazit všechny úkoly"
    echo "  done [číslo]    - Označit úkol jako splněný"
    echo "  delete [číslo]  - Smazat úkol"
    echo "  clear           - Smazat všechny úkoly"
    echo "  help            - Zobrazit tuto nápovědu"
}

# Funkce pro přidání úkolu
add_task() {
    if [ -z "$1" ]; then
        echo "Chyba: Musíte zadat text úkolu"
        echo "Příklad: $0 add \"Nakoupit mléko\""
        exit 1
    fi
    local date_created=$(date '+%Y-%m-%d %H:%M')
    echo "[ ]|$1|$date_created|" >> "$TODO_FILE"
    echo "✓ Úkol přidán: $1"
    echo "  Vytvořeno: $date_created"
}

# Funkce pro zobrazení seznamu
list_tasks() {
    if [ ! -s "$TODO_FILE" ]; then
        echo "Seznam úkolů je prázdný."
        return
    fi
    
    echo "=== SEZNAM ÚKOLŮ ==="
    local i=1
    while IFS='|' read -r status task date_created date_done; do
        echo "$i. $status $task"
        echo "   Vytvořeno: $date_created"
        if [ -n "$date_done" ]; then
            echo "   Splněno: $date_done"
        fi
        echo ""
        ((i++))
    done < "$TODO_FILE"
}

# Funkce pro označení úkolu jako splněného
mark_done() {
    if [ -z "$1" ]; then
        echo "Chyba: Musíte zadat číslo úkolu"
        exit 1
    fi
    
    local line_count=$(wc -l < "$TODO_FILE")
    
    if [ "$1" -gt "$line_count" ] || [ "$1" -lt 1 ]; then
        echo "Chyba: Neplatné číslo úkolu"
        exit 1
    fi
    
    local line=$(sed -n "${1}p" "$TODO_FILE")
    
    # Kontrola, zda již není splněno
    if [[ "$line" == "[X]|"* ]]; then
        echo "Tento úkol je již označen jako splněný"
        exit 0
    fi
    
    local date_done=$(date '+%Y-%m-%d %H:%M')
    local new_line=$(echo "$line" | sed "s/\[ \]/[X]/" | sed "s/|$/|$date_done/")
    
    sed -i "${1}s|.*|$new_line|" "$TODO_FILE"
    echo "✓ Úkol označen jako splněný"
    echo "  Splněno: $date_done"
}

# Funkce pro smazání úkolu
delete_task() {
    if [ -z "$1" ]; then
        echo "Chyba: Musíte zadat číslo úkolu"
        exit 1
    fi
    
    local line_count=$(wc -l < "$TODO_FILE")
    
    if [ "$1" -gt "$line_count" ] || [ "$1" -lt 1 ]; then
        echo "Chyba: Neplatné číslo úkolu"
        exit 1
    fi
    
    sed -i "${1}d" "$TODO_FILE"
    echo "✓ Úkol smazán"
}

# Funkce pro smazání všech úkolů
clear_all() {
    read -p "Opravdu chcete smazat všechny úkoly? (ano/ne): " confirm
    if [ "$confirm" = "ano" ]; then
        > "$TODO_FILE"
        echo "✓ Všechny úkoly smazány"
    else
        echo "Operace zrušena"
    fi
}

# Hlavní logika programu
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
    help|--help|-h)
        show_help
        ;;
    *)
        echo "Neznámá volba: $1"
        show_help
        exit 1
        ;;
esac
