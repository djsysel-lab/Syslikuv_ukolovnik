#!/bin/bash
       
        # Soubor pro uložení úkolů a historie
        
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
    echo -e "\e[31m CHYBA nenalezen soubor : barvyTextu.sh \e[0m "
    echo " Texty budou monochromatické"
fi

        # Pokusí se načíst funkce_todo.sh
        
if [ -f "./funkce_todo.sh" ];
then
    source ./funkce_todo.sh
    
else
    echo -e "\e[31m FATÁLNÍ CHYBA!! nenalezen soubor : funkce_todo.sh \e[0m "
    echo -e "\e[31m Nelze pokračovat \e[0m "
    esac
fi

        
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
    undone)
        mark_undone "$2"
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
        echo -e ""
        echo -e ""
        echo -e "${RED}Neznámý příkaz: $1 ${RESET}"
        show_help
        exit 1
        ;;
esac
