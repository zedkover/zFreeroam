-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Hôte : 127.0.0.1
-- Généré le : jeu. 26 août 2021 à 20:20
-- Version du serveur : 10.4.20-MariaDB
-- Version de PHP : 8.0.9

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données : `zfreeroam`
--

-- --------------------------------------------------------

--
-- Structure de la table `dpkeybinds`
--

CREATE TABLE `dpkeybinds` (
  `id` varchar(50) NOT NULL,
  `keybind1` varchar(50) DEFAULT 'num4',
  `emote1` varchar(255) DEFAULT '',
  `keybind2` varchar(50) DEFAULT 'num5',
  `emote2` varchar(255) DEFAULT '',
  `keybind3` varchar(50) DEFAULT 'num6',
  `emote3` varchar(255) DEFAULT '',
  `keybind4` varchar(50) DEFAULT 'num7',
  `emote4` varchar(255) DEFAULT '',
  `keybind5` varchar(50) DEFAULT 'num8',
  `emote5` varchar(255) DEFAULT '',
  `keybind6` varchar(50) DEFAULT 'num9',
  `emote6` varchar(255) DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Déchargement des données de la table `dpkeybinds`
--

INSERT INTO `dpkeybinds` (`id`, `keybind1`, `emote1`, `keybind2`, `emote2`, `keybind3`, `emote3`, `keybind4`, `emote4`, `keybind5`, `emote5`, `keybind6`, `emote6`) VALUES
('steam:11000014a032ed5', 'num4', '', 'num5', '', 'num6', '', 'num7', '', 'num8', '', 'num9', '');

-- --------------------------------------------------------

--
-- Structure de la table `users`
--

CREATE TABLE `users` (
  `identifier` varchar(50) COLLATE utf8mb4_bin NOT NULL,
  `license` varchar(50) COLLATE utf8mb4_bin DEFAULT NULL,
  `money` int(11) DEFAULT NULL,
  `name` varchar(50) COLLATE utf8mb4_bin DEFAULT '',
  `skin` longtext COLLATE utf8mb4_bin DEFAULT NULL,
  `loadout` longtext COLLATE utf8mb4_bin DEFAULT NULL,
  `position` varchar(36) COLLATE utf8mb4_bin DEFAULT NULL,
  `bank` int(11) DEFAULT NULL,
  `permission_level` int(11) DEFAULT NULL,
  `group` varchar(50) COLLATE utf8mb4_bin DEFAULT NULL,
  `status` longtext COLLATE utf8mb4_bin DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

--
-- Déchargement des données de la table `users`
--

INSERT INTO `users` (`identifier`, `license`, `money`, `name`, `skin`, `loadout`, `position`, `bank`, `permission_level`, `group`, `status`) VALUES
('steam:11000014a032ed5', 'license:462a8ff8f313fefeb1f86b8a3ab1d5a354f222be', 10000, 'Jus2Tomate', '{\"bodyb_1\":0,\"eyebrows_1\":0,\"bracelets_1\":-1,\"blemishes_2\":0,\"Hauteurdespommettes\":0,\"blush_1\":0,\"makeup_1\":0,\"blush_3\":0,\"beard_3\":0,\"glasses_1\":0,\"Epaisseurducou\":0,\"makeup_4\":0,\"Largeurnez\":0,\"tshirt_2\":0,\"mask_2\":0,\"lipstick_1\":0,\"Largeurdumenton\":0,\"helmet_1\":-1,\"Largeurdesjoues\":0,\"beard_1\":0,\"facepeds\":0,\"eyebrows_3\":0,\"hair_color_1\":0,\"blemishes_1\":0,\"Abaissementdumenton\":0,\"beard_4\":0,\"hair_1\":0,\"Hauteurnez\":0,\"watches_1\":-1,\"ears_2\":0,\"pants_2\":0,\"lipstick_4\":0,\"hair_color_2\":0,\"sun_2\":0,\"Troudumenton\":0,\"Hauteursourcils\":0,\"sun_1\":0,\"Longueurdelosdumenton\":0,\"lipstick_2\":0,\"Torsiondunez\":0,\"hair_2\":0,\"complexion_1\":0,\"Abaissementdunez\":0,\"watches_2\":0,\"facepeds2\":0,\"Profondeursourcils\":0,\"arms\":0,\"helmet_2\":0,\"bproof_1\":0,\"shoes_2\":0,\"decals_1\":0,\"mask_1\":0,\"chain_1\":0,\"complexion_2\":0,\"Epaisseurdeslevres\":0,\"Longueurnez\":0,\"chest_1\":0,\"chest_2\":0,\"skin\":0,\"torso_1\":0,\"Largeurdespommettes\":0,\"beard_2\":0,\"eyebrows_4\":0,\"moles_2\":0,\"bags_1\":0,\"bodyb_2\":0,\"blush_2\":0,\"sex\":0,\"makeup_2\":0,\"Abaissementpicdunez\":0,\"eyebrows_2\":0,\"pants_1\":0,\"chain_2\":0,\"glasses_2\":0,\"moles_1\":0,\"chest_3\":0,\"Longueurdudosdelamachoire\":0,\"ears_1\":-1,\"bracelets_2\":0,\"bags_2\":0,\"age_2\":0,\"bproof_2\":0,\"eye_color\":0,\"arms_2\":0,\"shoes_1\":0,\"age_1\":0,\"face\":0,\"Ouverturedesyeux\":0,\"lipstick_3\":0,\"torso_2\":0,\"Largeurdelamachoire\":0,\"tshirt_1\":0,\"makeup_3\":0,\"decals_2\":0}', '[]', '{\"z\":10.6,\"y\":-1121.8,\"x\":-748.8}', 40000, 0, 'user', NULL);

-- --------------------------------------------------------

--
-- Structure de la table `user_accounts`
--

CREATE TABLE `user_accounts` (
  `id` int(11) NOT NULL,
  `identifier` varchar(22) NOT NULL,
  `name` varchar(50) NOT NULL,
  `money` double NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Déchargement des données de la table `user_accounts`
--

INSERT INTO `user_accounts` (`id`, `identifier`, `name`, `money`) VALUES
(3, 'steam:11000013e993a14', 'black_money', 0),
(4, 'steam:11000014a032ed5', 'black_money', 0);

--
-- Index pour les tables déchargées
--

--
-- Index pour la table `dpkeybinds`
--
ALTER TABLE `dpkeybinds`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`identifier`);

--
-- Index pour la table `user_accounts`
--
ALTER TABLE `user_accounts`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT pour les tables déchargées
--

--
-- AUTO_INCREMENT pour la table `user_accounts`
--
ALTER TABLE `user_accounts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
