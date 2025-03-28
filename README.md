🏋️‍♂️ Script Salle de Sport - FiveM (QBCore)

Ce script permet aux joueurs d'améliorer leur force et leur résistance en effectuant différents exercices dans une salle de sport. Il utilise QBCore et oxmysql pour gérer la progression des compétences.

Info : le script est fonctionnel n'est pas parfait mais c'est une base pour vos développements

📌 Fonctionnalités

✔️ Plusieurs exercices disponibles :

    🏋️ Haltères → Augmente la force

    🤸 Pompes → Augmente la force

    🔄 Tractions → Augmente la résistance

    🧘 Yoga → Augmente la résistance

✔️ Progression sauvegardée en base de données
✔️ Affichage en 3D des actions disponibles
✔️ Barre de progression avec QB-Skillbar
✔️ Système de notification interactif
✔️ Optimisation des performances (boucles optimisées)
📂 Installation

1️⃣ Télécharge et ajoute le script à ton serveur
Place le dossier du script dans resources

2️⃣ Ajoute la ressource à ton server.cfg

ensure jeuxend-gym

3️⃣ Ajoute la colonne gym dans ta base de données players
Si elle n'existe pas, exécute cette requête SQL :

ALTER TABLE players ADD COLUMN gym INT DEFAULT 0;

4️⃣ Redémarre ton serveur FiveM 🚀
⚙️ Configuration

Le fichier config.lua te permet d'ajuster les lieux et paramètres du script.
📌 Exemple de configuration

Config.Locations = {
    [1] = { -- Tractions
        coords = vector3(-1200.02, -1571.18, 4.61), heading = 215.53,
        animation = "prop_human_muscle_chin_ups", skill = "resistance", SkillAddQuantity = 1,
        Text3D = "~b~E~w~ - [Faire des tractions]", viewDistance = 2.5,
    },
}

🔹 coords → Position de l'exercice
🔹 heading → Direction du joueur
🔹 animation → Animation jouée
🔹 skill → Type de compétence affectée (force ou résistance)
🔹 SkillAddQuantity → Points gagnés à chaque exercice
🔹 Text3D → Texte affiché en jeu
🔹 viewDistance → Distance d'affichage du texte
📜 Permissions & Dépendances

🔹 Framework : QBCore
🔹 Base de données : oxmysql
🔹 Skillbar : qb-skillbar
🎮 Utilisation

1️⃣ Dirige-toi vers un emplacement d'exercice 🏋️
2️⃣ Appuie sur E pour commencer
3️⃣ Termine la barre de progression pour valider l'exercice
4️⃣ Progresse jusqu'à 100 points de force/résistance

💪 Plus tu fais d'exercices, plus tu deviens fort !
🛠️ Développement
📌 Fonction principale


❓ Support

📢 Discord :  
🛠️ Issues : Ouvre un ticket sur GitHub si tu rencontres un problème



🎉 Amuse-toi bien sur FiveM et bon entraînement ! 🏋️🚀