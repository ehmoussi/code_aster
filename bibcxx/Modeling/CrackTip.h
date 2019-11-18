#ifndef CRACKTIP_H_
#define CRACKTIP_H_

/**
 * @file CrackTip.h
 * @brief Fichier entete de la classe CrackTip
 * @author Nicolas Sellenet
 * @section LICENCE
 *   Copyright (C) 1991 - 2019  EDF R&D                www.code-aster.org
 *
 *   This file is part of Code_Aster.
 *
 *   Code_Aster is free software: you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation, either version 3 of the License, or
 *   (at your option) any later version.
 *
 *   Code_Aster is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with Code_Aster.  If not, see <http://www.gnu.org/licenses/>.
 */

/* person_in_charge: nicolas.sellenet at edf.fr */

#include "DataFields/FieldOnNodes.h"
#include "DataStructures/DataStructure.h"
#include "MemoryManager/JeveuxVector.h"
#include "astercxx.h"

/**
 * @class CrackTipInstance
 * @brief Cette classe decrit un fond_fiss
 * @author Nicolas Sellenet
 */
class CrackTipInstance : public DataStructure {
  private:
    /** @brief Objet Jeveux '.INFO' */
    JeveuxVectorChar8 _info;
    /** @brief Objet Jeveux '.FONDFISS' */
    JeveuxVectorDouble _fondFiss;
    /** @brief Objet Jeveux '.FOND.TYPE' */
    JeveuxVectorChar8 _fondType;
    /** @brief Objet Jeveux '.FOND.NOEUD' */
    JeveuxVectorChar8 _fondNoeu;
    /** @brief Objet Jeveux '.FONDINF.NOEU' */
    JeveuxVectorChar8 _fondInfNoeu;
    /** @brief Objet Jeveux '.FONDSUP.NOEU' */
    JeveuxVectorChar8 _fondSupNoeu;
    /** @brief Objet Jeveux '.FONDFISG' */
    JeveuxVectorDouble _fondFisG;
    /** @brief Objet Jeveux '.NORMALE' */
    JeveuxVectorDouble _normale;
    /** @brief Objet Jeveux '.BASEFOND' */
    JeveuxVectorDouble _baseFond;
    /** @brief Objet Jeveux '.LTNO' */
    FieldOnNodesDoublePtr _ltno;
    /** @brief Objet Jeveux '.LNNO' */
    FieldOnNodesDoublePtr _lnno;
    /** @brief Objet Jeveux '.BASLOC' */
    FieldOnNodesDoublePtr _basLoc;
    /** @brief Objet Jeveux '.FOND.TAILLE_R' */
    JeveuxVectorDouble _fondTailleR;
    /** @brief Objet Jeveux '.DTAN_ORIGINE' */
    JeveuxVectorDouble _dtanOrigine;
    /** @brief Objet Jeveux '.DTAN_EXTREMITE' */
    JeveuxVectorDouble _dtanExtremite;
    /** @brief Objet Jeveux '.LEVRESUP.MAIL' */
    JeveuxVectorChar8 _levreSupMail;
    /** @brief Objet Jeveux '.SUPNORM.NOEU' */
    JeveuxVectorChar8 _supNormNoeu;
    /** @brief Objet Jeveux '.LEVREINF.MAIL' */
    JeveuxVectorChar8 _levreInfMail;
    /** @brief Objet Jeveux '.INFNORM.NOEU' */
    JeveuxVectorChar8 _infNormNoeud;

  public:
    /**
     * @typedef CrackTipPtr
     * @brief Pointeur intelligent vers un CrackTipInstance
     */
    typedef boost::shared_ptr< CrackTipInstance > CrackTipPtr;

    /**
     * @brief Constructeur
     */
    CrackTipInstance( const std::string name = ResultNaming::getNewResultName() );
};

/**
 * @typedef CrackTipPtr
 * @brief Pointeur intelligent vers un CrackTipInstance
 */
typedef boost::shared_ptr< CrackTipInstance > CrackTipPtr;

#endif /* CRACKTIP_H_ */
