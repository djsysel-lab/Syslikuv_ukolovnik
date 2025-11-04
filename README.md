  **Syslíkův úkolovník**
  
 Popis funkcí :

- Úkoly se ukládají do souboru : ~/ukolovnik/.todo_list.txt

- Historie se ukládá do souboru: ~/ukolovnik/.todo_history.log

- Script, si načítá další soubor *barvyTextu.sh* a *funkce_todo.sh*. Ověřuje, zda tyto soubory existují, pokd ne, vypíše chybu.
  
- Pokud existuje soubor "barvyTextu.sh" tak :
  - *chybové hlašky se zobrazují červeně*
  - *informativní světle modře*
  - *potvrzující hláška zlutě*
  
- Nesplněné úkoly mají označení [ ]

- Splněné úkoly mají označení [X]

- Úkol lze smazat jednotlivě (zadáním jeho čísla), ale i všehny najednou, u všech najednou vyžaduje potvrzení.

- Skript kontroluje správnost příkazů, v případě špatného zadání, vyvolá *help* (nápovědu).
  
- Lze vyvolat *help* (nápovědu).  
