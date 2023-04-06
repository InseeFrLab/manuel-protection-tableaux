# Manuel de pose du secret

Proposition de la DMRG (Julien Jamme, Nathanaël Rastout) du 27 mars 2023

- Format quarto book (un exemple ici: https://r4ds.hadley.nz/)
  - écriture des chapitres en markdown (formatage simplifié)
  - insertion facilitée de codes R
  - gestion des index et des chapitres automatisées
  - publication d'un manuel numérique facile à consulter
  - possibilité d'un export pdf pour ceux qui préfèrent

- Support de maintenance: dépôt github - en open source

- Manuel en français avec à terme l'ambition de le diffuser aussi en anglais.

- Philosophie du manuel:
  - outils:
    - Tau-Argus comme outil de référence de pose du secret
    - rtauargus comme outil de référence pour la mise en oeuvre
    - donc tout sur R
  - distinguer trois niveaux de difficultés dans les exemples:
    - débutant
    - intermédiaire
    - expert
  - opensource

- Utilisateurs:
  - Insee + SSP:
    - Chargé d'étude:
      - niveau débutant
      - Pose du secret très occasionnelle
    - Chargés de réponse à la demande DG + DR:
      - niveau intermédiaire à expert
      - avec une spécificité: les tableaux à la commune et des tableaux à 5 variables
    - Experts pose du secret Insee / SSM (ex Douanes, SSP) + experts européens:
      - spécificité: le nombre de tableaux qui peut être très grands

## Proposition de Plan

1. Partie un peu théorique sur les différents types de risque (réidentification, attributs, inférence et différenciation)
2. Règles à appliquer par source (besoin d'aide extérieure => DGUS)
   1. diffusion et demande sur mesure
   2. avec annexe règles additionnelles du type p% (niveau expert)
3. Notions à connaître:
   1. Tableaux d'effectifs et tableaux de magnitude
   2. Secret primaire et secret secondaire
   3. Variable hiérarchique 
   4. Hiérarchies non emboîtées
   5. Liaisons entre tableaux
   6. Tableau à diffuser vs tableau à protéger
4. Comment analyser une demande ?
   1. Détecter les liens 
   2. Passer de la liste de diffusion à la liste de protection
   3. Fiches d'exemples d'analyse de demandes
5. Présentation des outils
   1. Tau-Argus
      1. présnentation générale
      2. les différents algorithmes du secret secondaire
      3. Avantages et inconvénients
   2. package rtauargus
      1. Objectifs: poser le secret secondaire avec Tau-Argus sans l'ouvrir et gérer des grosses demandes
      2. Principales fonctionnalités
      3. Où trouver la doc ?
   3. Comment débugger ?
      1. les principales erreurs
      2. savoir lire les différents types de fichier spécifiques à Tau-Argus (rda, arb, hrc)
6. Fiches pratiques
   1. Poser le secret sur un tableau
   2. Prendre en compte une variable hiérarchique
   3. Comment poser le secret sur plusieurs tableaux liées (par les marges) ?
   4. Comment poser le secret en présence de hiérarchies non emboîtées
   5. Différenciation avec diffman (niveau expert pour traiter non emboitement epci * communes mais on pourrait envisager sur ttes hier non emb., si intégration de la gestion de la différenciation par recoupement directement dans rtauargus)
7. Annexes
   1. Travailler avec des listes en R (list, lapply, map, indexation, les noms)
   2. Fabriquer des tableaux à partir de données individuelles
   3. Une option manuelle
   4. Une option automatique (package dmrg)
8. Lexique ?

## Calendrier

- Priorités - V1 - Décembre 2023
    - Notions
    - Les outils
    - Comment analyser
    - Fiches Pratiques (en partie)
    - Règles par source (DGUS appui)
- V2 - Juin 2024
    - Fiches de niveaux experts
    - Partie introductive théorique sur les enjeux (risques)
    - Annexes