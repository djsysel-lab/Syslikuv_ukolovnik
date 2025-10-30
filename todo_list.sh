 #!/bin/bash

                # Soubor pro uložení úkolů


        TODO_FILE="$HOME/.todo_list.txt"


                # Vytvoření souboru, pokud neexistuje

        if [ ! -f "$TODO_FILE" ];
        then
    touch "$TODO_FILE"
        fi

    # Pokusí se načíst barvyTextu.sh

        if [ -f "./barvyTextu.sh" ];

                then
        source ./barvyTextu.sh

                        else
                echo " CHYBA nenalezen soubor : barvyTextu.sh "
                echo " Texty budou monochromatické"
        fi

                # Funkce pro zobrazení nápovědy


        show_help() {
        echo""
    echo "=== SEZNAM ÚKOLŮ ==="
    echo ""
    echo "Použití: $0 [příkaz]"
    echo ""
    echo "Volby:"
    echo "  add \"text\"      - Přidat nový úkol"
    echo "  list            - Zobrazit všechny úkoly"
    echo "  done [číslo]    - Označit úkol jako splněný"
    echo "  delete [číslo]  - Smazat úkol"
    echo "  clear           - Smazat všechny úkoly"
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
    echo "✓ Úkol přidán: $1"
        }

                # Funkce pro zobrazení seznamu


        list_tasks() {
    if [ ! -s "$TODO_FILE" ];
    then
       echo -e "${CYEN} Seznam úkolů je prázdný. ${RESET}"
        return
    fi

    echo "=== SEZNAM ÚKOLŮ ==="
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

    sed -i "${1}d" "$TODO_FILE"
   echo -e "${CYEN} ✓ Úkol smazán ${RESET}"
        }

                # Funkce pro smazání všech úkolů


        clear_all() {
    read -p  "Opravdu chcete smazat všechny úkoly? (ano/ne):" confirm
    if [ "$confirm" = "ano" ];
    then
        > "$TODO_FILE"
        echo -e "${CYEN} ✓ Všechny úkoly smazány ${RESET}"
    else
        echo -e "${CYEN} Operace zrušena {RESET}"
    fi
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
    help|--help|-h)
        show_help
        ;;
    *)
        echo -e "${RED}Neznámý příkaz: $1 ${RESET}"
        show_help
        exit 1
        ;;
esac
