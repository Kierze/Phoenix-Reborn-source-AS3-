SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

CREATE DATABASE IF NOT EXISTS phoenixrealms DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci;
USE phoenixrealms;

CREATE TABLE IF NOT EXISTS accountmiscdata (
  accId int(11) NOT NULL,
  unlockedMoods varchar(128) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS accounts (
  id int(11) NOT NULL,
  uuid varchar(128) NOT NULL,
  `password` varchar(256) NOT NULL,
  `name` varchar(64) NOT NULL,
  email varchar(128) NOT NULL,
  rank int(11) NOT NULL,
  tag varchar(11) NOT NULL,
  namechosen tinyint(1) NOT NULL,
  verified tinyint(1) NOT NULL,
  guild int(11) NOT NULL,
  guildRank int(11) NOT NULL,
  guildFame int(11) NOT NULL DEFAULT '0',
  vaultCount int(11) NOT NULL DEFAULT '1',
  maxCharSlot int(11) NOT NULL,
  regTime datetime NOT NULL,
  guest tinyint(1) NOT NULL,
  starred text NOT NULL,
  ignored text NOT NULL,
  banned tinyint(1) NOT NULL,
  beginnerPackageTimeLeft int(11) NOT NULL DEFAULT '0',
  locked text NOT NULL,
  muted tinyint(1) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS behavior (
  accId int(11) NOT NULL,
  priority int(11) NOT NULL DEFAULT '0',
  total int(11) NOT NULL DEFAULT '0',
  infraction varchar(256) DEFAULT NULL,
  liftTime datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS boards (
  guildId int(11) NOT NULL,
  `text` varchar(1024) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS characters (
  id int(11) NOT NULL,
  accId int(11) NOT NULL,
  charId int(11) NOT NULL,
  charType int(11) NOT NULL,
  `level` int(11) NOT NULL,
  exp int(11) NOT NULL,
  fame int(11) NOT NULL,
  items text NOT NULL,
  itemDatas longtext NOT NULL,
  hp int(11) NOT NULL,
  mp int(11) NOT NULL,
  stats varchar(64) NOT NULL,
  deaths int(11) NOT NULL,
  tex1 int(11) NOT NULL,
  tex2 int(11) NOT NULL,
  effect longtext NOT NULL,
  skin int(11) NOT NULL DEFAULT '-1',
  permaSkin int(11) NOT NULL,
  pet int(11) NOT NULL,
  xpboost tinyint(1) NOT NULL,
  floors int(11) NOT NULL,
  fameStats text NOT NULL,
  abilitySpec varchar(64) NOT NULL,
  createTime timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  deathTime timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  totalFame int(11) NOT NULL,
  mood varchar(32) NOT NULL DEFAULT 'Neutral',
  maxLevel int(11) NOT NULL DEFAULT '1'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS classstats (
  accId int(11) NOT NULL,
  objType int(11) NOT NULL,
  bestLv int(11) NOT NULL,
  bestFame int(11) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS death (
  accId int(11) NOT NULL,
  chrId int(11) NOT NULL,
  `name` varchar(64) NOT NULL,
  charType int(11) NOT NULL,
  tex1 int(11) NOT NULL,
  tex2 int(11) NOT NULL,
  skin int(11) NOT NULL DEFAULT '-1',
  items text NOT NULL,
  itemDatas longtext NOT NULL,
  fame int(11) NOT NULL,
  fameStats text NOT NULL,
  totalFame int(11) NOT NULL,
  firstBorn tinyint(1) NOT NULL,
  killer varchar(128) NOT NULL,
  `time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS emails (
  accId int(11) NOT NULL,
  `name` varchar(16) NOT NULL,
  email varchar(128) NOT NULL,
  accessKey varchar(40) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS gamesettings (
  setting varchar(32) NOT NULL,
  `value` double DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS globalprogress (
  attribute varchar(32) NOT NULL,
  completed tinyint(1) NOT NULL DEFAULT '0',
  progress varchar(32) NOT NULL,
  `timestamp` datetime DEFAULT NULL,
  `Global` tinyint(1) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS guilds (
  id int(11) NOT NULL,
  `name` varchar(128) NOT NULL DEFAULT 'DEFAULT_GUILD',
  members varchar(128) NOT NULL,
  guildFame int(11) NOT NULL,
  totalGuildFame int(11) NOT NULL,
  `level` int(11) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS market (
  id int(11) NOT NULL,
  accId int(11) NOT NULL,
  `status` smallint(1) NOT NULL DEFAULT '0',
  offerItems text NOT NULL,
  offerData longtext NOT NULL,
  requestItems text NOT NULL,
  requestData longtext NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS news (
  id int(11) NOT NULL,
  icon varchar(16) NOT NULL,
  title varchar(128) NOT NULL,
  `text` varchar(128) NOT NULL,
  link varchar(256) NOT NULL,
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS offers (
  id int(11) NOT NULL,
  price int(11) NOT NULL,
  gold int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS sprites (
  id int(11) NOT NULL,
  guid varchar(128) NOT NULL,
  `name` varchar(256) NOT NULL,
  dataType int(11) NOT NULL,
  tags text NOT NULL,
  `data` longblob NOT NULL,
  fileSize int(11) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS stats (
  accId int(11) NOT NULL,
  fame int(11) NOT NULL,
  totalFame int(11) NOT NULL,
  credits int(11) NOT NULL,
  totalCredits int(11) NOT NULL,
  silver int(11) NOT NULL,
  totalSilver int(11) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS unlockedclasses (
  id int(11) NOT NULL,
  accId int(11) NOT NULL,
  class varchar(32) NOT NULL,
  available varchar(64) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS vaults (
  accId int(11) NOT NULL,
  chestId int(11) NOT NULL,
  items text NOT NULL,
  itemDatas longtext NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;


ALTER TABLE accountmiscdata
  ADD PRIMARY KEY (accId);

ALTER TABLE accounts
  ADD PRIMARY KEY (id,email);

ALTER TABLE behavior
  ADD PRIMARY KEY (accId);

ALTER TABLE boards
  ADD PRIMARY KEY (guildId);

ALTER TABLE characters
  ADD PRIMARY KEY (id);

ALTER TABLE classstats
  ADD PRIMARY KEY (accId,objType);

ALTER TABLE death
  ADD PRIMARY KEY (accId,chrId);

ALTER TABLE emails
  ADD PRIMARY KEY (accId),
  ADD UNIQUE KEY email (email);

ALTER TABLE gamesettings
  ADD PRIMARY KEY (setting);

ALTER TABLE globalprogress
  ADD PRIMARY KEY (attribute);

ALTER TABLE guilds
  ADD PRIMARY KEY (id,members);

ALTER TABLE market
  ADD PRIMARY KEY (id);

ALTER TABLE news
  ADD PRIMARY KEY (id);

ALTER TABLE offers
  ADD PRIMARY KEY (id);

ALTER TABLE sprites
  ADD PRIMARY KEY (id);

ALTER TABLE stats
  ADD PRIMARY KEY (accId);

ALTER TABLE unlockedclasses
  ADD PRIMARY KEY (id);

ALTER TABLE vaults
  ADD PRIMARY KEY (accId,chestId);


ALTER TABLE accountmiscdata
  MODIFY accId int(11) NOT NULL AUTO_INCREMENT;
ALTER TABLE accounts
  MODIFY id int(11) NOT NULL AUTO_INCREMENT;
ALTER TABLE behavior
  MODIFY accId int(11) NOT NULL AUTO_INCREMENT;
ALTER TABLE characters
  MODIFY id int(11) NOT NULL AUTO_INCREMENT;
ALTER TABLE emails
  MODIFY accId int(11) NOT NULL AUTO_INCREMENT;
ALTER TABLE guilds
  MODIFY id int(11) NOT NULL AUTO_INCREMENT;
ALTER TABLE market
  MODIFY id int(11) NOT NULL AUTO_INCREMENT;
ALTER TABLE news
  MODIFY id int(11) NOT NULL AUTO_INCREMENT;
ALTER TABLE offers
  MODIFY id int(11) NOT NULL AUTO_INCREMENT;
ALTER TABLE sprites
  MODIFY id int(11) NOT NULL AUTO_INCREMENT;
ALTER TABLE unlockedclasses
  MODIFY id int(11) NOT NULL AUTO_INCREMENT;
ALTER TABLE vaults
  MODIFY chestId int(11) NOT NULL AUTO_INCREMENT;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
