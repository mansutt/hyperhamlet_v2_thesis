-- MySQL dump 10.14  Distrib 5.5.60-MariaDB, for Linux (x86_64)
--
-- Host: localhost    Database: hamlet2
-- ------------------------------------------------------
-- Server version	5.5.60-MariaDB

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `authormarks`
--

DROP TABLE IF EXISTS `authormarks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `authormarks` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `name` varchar(64) NOT NULL,
  `sortorder` int(10) NOT NULL,
  `parent` int(10) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `authormarks`
--

LOCK TABLES `authormarks` WRITE;
/*!40000 ALTER TABLE `authormarks` DISABLE KEYS */;
/*!40000 ALTER TABLE `authormarks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `authors`
--

DROP TABLE IF EXISTS `authors`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `authors` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `lastname` varchar(64) DEFAULT NULL,
  `firstname` varchar(64) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4716 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `authors`
--

LOCK TABLES `authors` WRITE;
/*!40000 ALTER TABLE `authors` DISABLE KEYS */;
/*!40000 ALTER TABLE `authors` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `authors_citations`
--

DROP TABLE IF EXISTS `authors_citations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `authors_citations` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `author_id` int(10) NOT NULL,
  `citation_id` int(10) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `author_authors_citations_fk` (`author_id`),
  KEY `authors_citations_citation_fk` (`citation_id`),
  CONSTRAINT `authors_citations_citation_fk` FOREIGN KEY (`citation_id`) REFERENCES `citations` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `author_authors_citations_fk` FOREIGN KEY (`author_id`) REFERENCES `authors` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=121978 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `authors_citations`
--

LOCK TABLES `authors_citations` WRITE;
/*!40000 ALTER TABLE `authors_citations` DISABLE KEYS */;
/*!40000 ALTER TABLE `authors_citations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `citations`
--

DROP TABLE IF EXISTS `citations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `citations` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `text` text NOT NULL,
  `title` varchar(255) NOT NULL,
  `year_from` int(10) DEFAULT NULL,
  `year_to` int(10) DEFAULT NULL,
  `cyear_from` int(10) DEFAULT NULL,
  `cyear_to` int(10) DEFAULT NULL,
  `linktext` varchar(255) DEFAULT NULL,
  `contributor_id` int(10) DEFAULT NULL,
  `bibliography` text,
  `comment` text,
  `esource` text,
  `internal_comment` text,
  `secsrc_txt` text,
  `language_id` int(10) DEFAULT NULL,
  `genre_id` int(10) DEFAULT NULL,
  `authormark_id` int(10) DEFAULT NULL,
  `entry_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `firstpage_reference` tinyint(1) DEFAULT '0',
  `ok_date` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `last_modif` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `statusflag` enum('ok','annotation','unedited','provisional') NOT NULL DEFAULT 'unedited',
  PRIMARY KEY (`id`),
  KEY `citation_authormark_fk` (`authormark_id`),
  KEY `genre_citation_fk` (`genre_id`),
  KEY `contributor_citation_fk` (`contributor_id`),
  KEY `language_citation_fk` (`language_id`),
  KEY `statusflag_index` (`statusflag`),
  CONSTRAINT `citation_authormark_fk` FOREIGN KEY (`authormark_id`) REFERENCES `authormarks` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `contributor_citation_fk` FOREIGN KEY (`contributor_id`) REFERENCES `contributors` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `language_citation_fk` FOREIGN KEY (`language_id`) REFERENCES `languages` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=25767 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `citations`
--

LOCK TABLES `citations` WRITE;
/*!40000 ALTER TABLE `citations` DISABLE KEYS */;
/*!40000 ALTER TABLE `citations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `citations_generals`
--

DROP TABLE IF EXISTS `citations_generals`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `citations_generals` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `general_id` int(10) NOT NULL,
  `citation_id` int(10) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `citation_categories_citations_generals_fk` (`general_id`),
  KEY `citation_citations_generals_fk` (`citation_id`),
  CONSTRAINT `citation_categories_citations_generals_fk` FOREIGN KEY (`general_id`) REFERENCES `generals` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `citation_citations_generals_fk` FOREIGN KEY (`citation_id`) REFERENCES `citations` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=5401 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `citations_generals`
--

LOCK TABLES `citations_generals` WRITE;
/*!40000 ALTER TABLE `citations_generals` DISABLE KEYS */;
/*!40000 ALTER TABLE `citations_generals` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `citations_hamlettext`
--

DROP TABLE IF EXISTS `citations_hamlettext`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `citations_hamlettext` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `hamlettext_id` int(10) NOT NULL,
  `citation_id` int(10) NOT NULL,
  `linecategory_id` int(10) DEFAULT NULL,
  `is_tobe` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `line_category_citations_hamlettext_fk` (`linecategory_id`),
  KEY `citations_hamlettext_hamlettext_fk` (`hamlettext_id`),
  KEY `citations_hamlettext_citation_fk` (`citation_id`),
  CONSTRAINT `citations_hamlettext_citation_fk` FOREIGN KEY (`citation_id`) REFERENCES `citations` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `citations_hamlettext_hamlettext_fk` FOREIGN KEY (`hamlettext_id`) REFERENCES `hamlettext` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `line_category_citations_hamlettext_fk` FOREIGN KEY (`linecategory_id`) REFERENCES `linecategories` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=26534 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `citations_hamlettext`
--

LOCK TABLES `citations_hamlettext` WRITE;
/*!40000 ALTER TABLE `citations_hamlettext` DISABLE KEYS */;
/*!40000 ALTER TABLE `citations_hamlettext` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `citations_intertextuals`
--

DROP TABLE IF EXISTS `citations_intertextuals`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `citations_intertextuals` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `intertextual_id` int(10) NOT NULL,
  `citation_id` int(10) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `intertextual_relation_citations_intertextuals_relation_fk` (`intertextual_id`),
  KEY `citations_intertextuals_relation_citation_fk` (`citation_id`),
  CONSTRAINT `citations_intertextuals_relation_citation_fk` FOREIGN KEY (`citation_id`) REFERENCES `citations` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `intertextual_relation_citations_intertextuals_relation_fk` FOREIGN KEY (`intertextual_id`) REFERENCES `intertextuals` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=18383 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `citations_intertextuals`
--

LOCK TABLES `citations_intertextuals` WRITE;
/*!40000 ALTER TABLE `citations_intertextuals` DISABLE KEYS */;
/*!40000 ALTER TABLE `citations_intertextuals` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `citations_modifications`
--

DROP TABLE IF EXISTS `citations_modifications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `citations_modifications` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `citation_id` int(10) NOT NULL,
  `modification_id` int(10) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `modifications_citations_modifications_fk` (`modification_id`),
  KEY `citations_citations_modifications_fk` (`citation_id`),
  CONSTRAINT `citations_citations_modifications_fk` FOREIGN KEY (`citation_id`) REFERENCES `citations` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `modifications_citations_modifications_fk` FOREIGN KEY (`modification_id`) REFERENCES `modifications` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=27224 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `citations_modifications`
--

LOCK TABLES `citations_modifications` WRITE;
/*!40000 ALTER TABLE `citations_modifications` DISABLE KEYS */;
/*!40000 ALTER TABLE `citations_modifications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `citations_narratives`
--

DROP TABLE IF EXISTS `citations_narratives`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `citations_narratives` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `narrative_id` int(10) NOT NULL,
  `citation_id` int(10) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `narrative_voice_citations_narratives_fk` (`narrative_id`),
  KEY `citation_citations_narratives_fk` (`citation_id`),
  CONSTRAINT `citation_citations_narratives_fk` FOREIGN KEY (`citation_id`) REFERENCES `citations` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `narrative_voice_citations_narratives_fk` FOREIGN KEY (`narrative_id`) REFERENCES `narratives` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=17044 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `citations_narratives`
--

LOCK TABLES `citations_narratives` WRITE;
/*!40000 ALTER TABLE `citations_narratives` DISABLE KEYS */;
/*!40000 ALTER TABLE `citations_narratives` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `citations_overlaps`
--

DROP TABLE IF EXISTS `citations_overlaps`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `citations_overlaps` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `overlap_id` int(10) NOT NULL,
  `citation_id` int(10) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `overlaps_citations_overlaps_fk` (`overlap_id`),
  KEY `citations_citations_overlaps_fk` (`citation_id`),
  CONSTRAINT `citations_citations_overlaps_fk` FOREIGN KEY (`citation_id`) REFERENCES `citations` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `overlaps_citations_overlaps_fk` FOREIGN KEY (`overlap_id`) REFERENCES `overlaps` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=19713 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `citations_overlaps`
--

LOCK TABLES `citations_overlaps` WRITE;
/*!40000 ALTER TABLE `citations_overlaps` DISABLE KEYS */;
/*!40000 ALTER TABLE `citations_overlaps` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `citations_quotmarks`
--

DROP TABLE IF EXISTS `citations_quotmarks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `citations_quotmarks` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `quotmark_id` int(10) NOT NULL,
  `citation_id` int(10) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `quotmarks_citations_quotmarks_fk` (`quotmark_id`),
  KEY `citations_citations_quotmarks_fk` (`citation_id`),
  CONSTRAINT `citations_citations_quotmarks_fk` FOREIGN KEY (`citation_id`) REFERENCES `citations` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `quotmarks_citations_quotmarks_fk` FOREIGN KEY (`quotmark_id`) REFERENCES `quotmarks` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=24886 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `citations_quotmarks`
--

LOCK TABLES `citations_quotmarks` WRITE;
/*!40000 ALTER TABLE `citations_quotmarks` DISABLE KEYS */;
/*!40000 ALTER TABLE `citations_quotmarks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `citations_secondaries`
--

DROP TABLE IF EXISTS `citations_secondaries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `citations_secondaries` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `secondary_id` int(10) NOT NULL,
  `citation_id` int(10) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `secondary_source_citations_secondaries_fk` (`secondary_id`),
  KEY `citation_citations_secondaries_fk` (`citation_id`),
  CONSTRAINT `citation_citations_secondaries_fk` FOREIGN KEY (`citation_id`) REFERENCES `citations` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `secondary_source_citations_secondaries_fk` FOREIGN KEY (`secondary_id`) REFERENCES `secondaries` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=22218 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `citations_secondaries`
--

LOCK TABLES `citations_secondaries` WRITE;
/*!40000 ALTER TABLE `citations_secondaries` DISABLE KEYS */;
/*!40000 ALTER TABLE `citations_secondaries` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `citations_subjects`
--

DROP TABLE IF EXISTS `citations_subjects`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `citations_subjects` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `citation_id` int(10) NOT NULL,
  `subject_id` int(10) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `subject_citations_subjects_fk` (`subject_id`),
  KEY `citation_citations_subjects_fk` (`citation_id`),
  CONSTRAINT `citation_citations_subjects_fk` FOREIGN KEY (`citation_id`) REFERENCES `citations` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `subject_citations_subjects_fk` FOREIGN KEY (`subject_id`) REFERENCES `subjects` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=25533 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `citations_subjects`
--

LOCK TABLES `citations_subjects` WRITE;
/*!40000 ALTER TABLE `citations_subjects` DISABLE KEYS */;
/*!40000 ALTER TABLE `citations_subjects` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `citations_textuals`
--

DROP TABLE IF EXISTS `citations_textuals`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `citations_textuals` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `citation_id` int(10) NOT NULL,
  `textual_id` int(10) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `textual_function_citations_textuals_fk` (`textual_id`),
  KEY `citation_citations_textuals_fk` (`citation_id`),
  CONSTRAINT `citation_citations_textuals_fk` FOREIGN KEY (`citation_id`) REFERENCES `citations` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `textual_function_citations_textuals_fk` FOREIGN KEY (`textual_id`) REFERENCES `textuals` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=19423 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `citations_textuals`
--

LOCK TABLES `citations_textuals` WRITE;
/*!40000 ALTER TABLE `citations_textuals` DISABLE KEYS */;
/*!40000 ALTER TABLE `citations_textuals` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `citations_workmarks`
--

DROP TABLE IF EXISTS `citations_workmarks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `citations_workmarks` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `citation_id` int(10) NOT NULL,
  `workmark_id` int(10) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `workmark_workmark_text_fk` (`workmark_id`),
  KEY `citation_workmark_text_fk` (`citation_id`),
  CONSTRAINT `citation_workmark_text_fk` FOREIGN KEY (`citation_id`) REFERENCES `citations` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `workmark_workmark_text_fk` FOREIGN KEY (`workmark_id`) REFERENCES `workmarks` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=20623 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `citations_workmarks`
--

LOCK TABLES `citations_workmarks` WRITE;
/*!40000 ALTER TABLE `citations_workmarks` DISABLE KEYS */;
/*!40000 ALTER TABLE `citations_workmarks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `contributors`
--

DROP TABLE IF EXISTS `contributors`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `contributors` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `lastname` varchar(64) NOT NULL,
  `firstname` varchar(64) DEFAULT NULL,
  `email` varchar(128) DEFAULT NULL,
  `is_public_email` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=197 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `contributors`
--

LOCK TABLES `contributors` WRITE;
/*!40000 ALTER TABLE `contributors` DISABLE KEYS */;
/*!40000 ALTER TABLE `contributors` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `generals`
--

DROP TABLE IF EXISTS `generals`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `generals` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `name` varchar(64) NOT NULL,
  `sortorder` int(10) NOT NULL,
  `parent` int(10) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=523 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `generals`
--

LOCK TABLES `generals` WRITE;
/*!40000 ALTER TABLE `generals` DISABLE KEYS */;
/*!40000 ALTER TABLE `generals` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `genres`
--

DROP TABLE IF EXISTS `genres`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `genres` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `name` varchar(64) DEFAULT NULL,
  `supergenre` enum('Fiction','Nonfiction','Other') DEFAULT NULL,
  `sortorder` int(10) NOT NULL,
  `parent` int(10) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=408 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `genres`
--

LOCK TABLES `genres` WRITE;
/*!40000 ALTER TABLE `genres` DISABLE KEYS */;
/*!40000 ALTER TABLE `genres` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hamlettext`
--

DROP TABLE IF EXISTS `hamlettext`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `hamlettext` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `line` varchar(255) DEFAULT NULL,
  `line_no` int(10) NOT NULL,
  `comment` varchar(255) DEFAULT NULL,
  `act` tinyint(10) NOT NULL,
  `scene` tinyint(10) NOT NULL,
  `type` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8248 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hamlettext`
--

LOCK TABLES `hamlettext` WRITE;
/*!40000 ALTER TABLE `hamlettext` DISABLE KEYS */;
/*!40000 ALTER TABLE `hamlettext` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `intertextuals`
--

DROP TABLE IF EXISTS `intertextuals`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `intertextuals` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `name` varchar(64) NOT NULL,
  `sortorder` int(10) NOT NULL,
  `parent` int(10) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=87 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `intertextuals`
--

LOCK TABLES `intertextuals` WRITE;
/*!40000 ALTER TABLE `intertextuals` DISABLE KEYS */;
/*!40000 ALTER TABLE `intertextuals` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `languages`
--

DROP TABLE IF EXISTS `languages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `languages` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `name` varchar(64) NOT NULL,
  `sortorder` int(10) NOT NULL,
  `parent` int(10) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=128 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `languages`
--

LOCK TABLES `languages` WRITE;
/*!40000 ALTER TABLE `languages` DISABLE KEYS */;
/*!40000 ALTER TABLE `languages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `linecategories`
--

DROP TABLE IF EXISTS `linecategories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `linecategories` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `name` varchar(64) NOT NULL,
  `sortorder` int(10) NOT NULL,
  `parent` int(10) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2069 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `linecategories`
--

LOCK TABLES `linecategories` WRITE;
/*!40000 ALTER TABLE `linecategories` DISABLE KEYS */;
/*!40000 ALTER TABLE `linecategories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `modifications`
--

DROP TABLE IF EXISTS `modifications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `modifications` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `sortorder` int(10) NOT NULL,
  `parent` int(10) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2164 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `modifications`
--

LOCK TABLES `modifications` WRITE;
/*!40000 ALTER TABLE `modifications` DISABLE KEYS */;
/*!40000 ALTER TABLE `modifications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `narratives`
--

DROP TABLE IF EXISTS `narratives`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `narratives` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `name` varchar(64) NOT NULL,
  `sortorder` int(10) NOT NULL,
  `parent` int(10) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=149 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `narratives`
--

LOCK TABLES `narratives` WRITE;
/*!40000 ALTER TABLE `narratives` DISABLE KEYS */;
/*!40000 ALTER TABLE `narratives` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `overlaps`
--

DROP TABLE IF EXISTS `overlaps`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `overlaps` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `sortorder` int(10) DEFAULT NULL,
  `parent` int(10) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=106 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `overlaps`
--

LOCK TABLES `overlaps` WRITE;
/*!40000 ALTER TABLE `overlaps` DISABLE KEYS */;
/*!40000 ALTER TABLE `overlaps` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `quotmarks`
--

DROP TABLE IF EXISTS `quotmarks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `quotmarks` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `sortorder` int(10) NOT NULL,
  `parent` int(10) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=143 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `quotmarks`
--

LOCK TABLES `quotmarks` WRITE;
/*!40000 ALTER TABLE `quotmarks` DISABLE KEYS */;
/*!40000 ALTER TABLE `quotmarks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `roles`
--

DROP TABLE IF EXISTS `roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `roles` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(32) NOT NULL,
  `description` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniq_name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roles`
--

LOCK TABLES `roles` WRITE;
/*!40000 ALTER TABLE `roles` DISABLE KEYS */;
/*!40000 ALTER TABLE `roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `roles_users`
--

DROP TABLE IF EXISTS `roles_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `roles_users` (
  `user_id` int(10) unsigned NOT NULL,
  `role_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`user_id`,`role_id`),
  KEY `fk_role_id` (`role_id`),
  CONSTRAINT `roles_users_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `roles_users_ibfk_2` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roles_users`
--

LOCK TABLES `roles_users` WRITE;
/*!40000 ALTER TABLE `roles_users` DISABLE KEYS */;
/*!40000 ALTER TABLE `roles_users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `secondaries`
--

DROP TABLE IF EXISTS `secondaries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `secondaries` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `sortorder` int(10) NOT NULL,
  `parent` int(10) DEFAULT NULL,
  `name` varchar(64) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=84 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `secondaries`
--

LOCK TABLES `secondaries` WRITE;
/*!40000 ALTER TABLE `secondaries` DISABLE KEYS */;
/*!40000 ALTER TABLE `secondaries` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `subjects`
--

DROP TABLE IF EXISTS `subjects`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `subjects` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `sortorder` int(10) NOT NULL,
  `parent` int(10) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=388 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `subjects`
--

LOCK TABLES `subjects` WRITE;
/*!40000 ALTER TABLE `subjects` DISABLE KEYS */;
/*!40000 ALTER TABLE `subjects` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `textuals`
--

DROP TABLE IF EXISTS `textuals`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `textuals` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `sortorder` int(10) NOT NULL,
  `parent` int(10) DEFAULT NULL,
  `name` varchar(64) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=155 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `textuals`
--

LOCK TABLES `textuals` WRITE;
/*!40000 ALTER TABLE `textuals` DISABLE KEYS */;
/*!40000 ALTER TABLE `textuals` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_tokens`
--

DROP TABLE IF EXISTS `user_tokens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_tokens` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(11) unsigned NOT NULL,
  `user_agent` varchar(40) NOT NULL,
  `token` varchar(32) NOT NULL,
  `created` int(10) unsigned NOT NULL,
  `expires` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniq_token` (`token`),
  KEY `fk_user_id` (`user_id`),
  CONSTRAINT `user_tokens_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_tokens`
--

LOCK TABLES `user_tokens` WRITE;
/*!40000 ALTER TABLE `user_tokens` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_tokens` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `email` varchar(127) NOT NULL,
  `username` varchar(32) NOT NULL DEFAULT '',
  `password` char(50) NOT NULL,
  `logins` int(10) unsigned NOT NULL DEFAULT '0',
  `last_login` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniq_username` (`username`),
  UNIQUE KEY `uniq_email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `workmarks`
--

DROP TABLE IF EXISTS `workmarks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `workmarks` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `name` varchar(64) NOT NULL,
  `sortorder` int(10) NOT NULL,
  `parent` int(10) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=124 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `workmarks`
--

LOCK TABLES `workmarks` WRITE;
/*!40000 ALTER TABLE `workmarks` DISABLE KEYS */;
/*!40000 ALTER TABLE `workmarks` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2021-01-30 18:18:09
