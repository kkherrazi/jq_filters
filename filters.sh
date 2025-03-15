#!/bin/bash
echo "1. Affiche le nombre d'attributs par document ainsi que l'attribut name. Combien y a-t-il d'attribut par document ? N'affichez que les 12 premières lignes avec la commande head (notebook #2).attributes_count"
cat ../people.json  | jq .[] | jq '{name, attribute_count: length }' | head -n 12
echo "Commande : cat ../people.json  | jq .[] | jq '{name, attribute_count: length }' | head -n 12"
echo "Réponse : 17"
echo -e "\n---------------------------------\n"

echo "2. Combien y a-t-il de valeur "unknown" pour l'attribut "birth_year" ? Utilisez la commande tail afin d'isoler la réponse"
cat ../people.json | jq 'group_by(.birth_year)[] | {gender: .[0].birth_year, count: length}'  | tail -n 4
echo "Commande : cat ../people.json | jq 'group_by(.birth_year)[] | {gender: .[0].birth_year, count: length}'  | tail -n 4"
echo "Réponse : 42"
echo -e "\n---------------------------------\n"
 
echo "3. Affiche la date de création de chaque personnage et son nom. La date de création doit être de cette forme : l'année, le mois et le jour. N'affichez que les 10 premières lignes. (Pas de Réponse attendue)"
cat ../people.json  | jq .[] | jq '{name, created: .created[:10]}' | head -n 10
echo "Commande : cat ../people.json  | jq .[] | jq '{name, created: .created[:10] }' | head -n 10 "
echo -e "\n---------------------------------\n"

echo "4. Certains personnages sont nés en même temps. Retrouver toutes les pairs d'ids (2 ids) des personnages nés en même temps."
cat ../people.json  | jq 'group_by(.birth_year) | map((first | {birth_year}) + {ids: map({id})})' | jq '.[] | select(.ids | length == 2)'
echo "Commande :  cat ../people.json  | jq 'group_by(.birth_year) | map((first | {birth_year}) + {ids: map({id})})' | jq '.[] | select(.ids | length == 2)'
 "
echo -e "\n---------------------------------\n"

echo "5. Renvoyer le numéro du premier film (de la liste) dans lequel chaque personnage a été vu suivi du nom du personnage. N'afficher que les 10 premières lignes. (Pas de Réponse attendue)"
cat ../people.json  | jq .[] | jq '{first_movie : .films[1] | ltrimstr("http://swapi.co/api/films/") | rtrimstr("/") , name }' | head -n 12
echo "Commande :  cat ../people.json  | jq .[] | jq '{first_movie : .films[1] | ltrimstr("http://swapi.co/api/films/") | rtrimstr("/") , name }' | head -n 10"
echo -e "\n---------------------------------\n"

echo -e "\n----------------BONUS----------------\n"

# create bonus dir, if does not exists

BONUS_DIR="bonus" 
if [ ! -d "$BONUS_DIR" ]; then
   mkdir $BONUS_DIR
fi

function bonus_exercice_file_path () {
    echo $BONUS_DIR/people_$1.txt
}  

echo -e "\n---------------------------------\n"

echo "6. Supprimer les documents lorsque l'attribut height n'est pas un nombre"
cat ../people.json | jq 'del(.[] | select(.height | test("[^0-9]")))'  > `bonus_exercice_file_path 6` 
echo "Commande :  cat ../people.json | jq 'del(.[] | select(.height | test("[^0-9]")))'  > `bonus_exercice_file_path 6`" 
echo -e "\n---------------------------------\n"

echo "7. Transformer l'attribut height en nombre."
cat `bonus_exercice_file_path 6` | jq 'map(.height |= tonumber)'  > `bonus_exercice_file_path 7` 
echo "Commande :  cat `bonus_exercice_file_path 6` | jq 'map(.height |= tonumber)'  > `bonus_exercice_file_path 7`" 
echo -e "\n---------------------------------\n"

echo "8. Ne renvoyer que les personnages dont la taille est entre 156 et 171."
cat `bonus_exercice_file_path 7` | jq 'map(select( .height  > 156 and .height < 171 ))' > `bonus_exercice_file_path 8`  
echo "Commande :   cat `bonus_exercice_file_path 7` | jq 'map(select( .height  > 156 and .height < 171 ))' > `bonus_exercice_file_path 8`" 
echo -e "\n---------------------------------\n"

echo "9. Renvoyez le plus petit individu de people_8.json et affichez cette phrase en une seule commande."
cat `bonus_exercice_file_path 8` | jq 'min_by(.height) | "\(.name) is \(.height) tall"'  > `bonus_exercice_file_path 9`  
echo "Commande :   cat `bonus_exercice_file_path 8` | jq 'min_by(.height) | \"\(.name) is \(.height) tall\"'  > `bonus_exercice_file_path 9`" 
echo -e "\n---------------------------------\n"