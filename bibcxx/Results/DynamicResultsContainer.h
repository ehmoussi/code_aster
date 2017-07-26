#ifndef DYNAMICRESULTSCONTAINER_H_
#define DYNAMICRESULTSCONTAINER_H_

/**
 * @file DynamicResultsContainer.h
 * @brief Fichier entete de la classe DynamicResultsContainer
 * @author Natacha Béreux 
 * @section LICENCE
 *   Copyright (C) 1991 - 2017  EDF R&D                www.code-aster.org
 *
 *   This file is part of Code_Aster.
 *
 *   Code_Aster is free software: you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation, either version 2 of the License, or
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

/* person_in_charge: natacha.bereux at edf.fr */

#include "astercxx.h"

#include "DataStructures/DataStructure.h"
#include "MemoryManager/JeveuxVector.h"
#include "MemoryManager/JeveuxCollection.h"

/**
 * @class DynamicResultsContainerInstance
 * @brief Cette classe correspond a la sd_resu_dyna de Code_Aster.
 * Un objet sd_resu_dyna est un concept produit par un opérateur 
 * dynamique sur base physique ou base généralisée.
 * @author Natacha Béreux 
 */
class DynamicResultsContainerInstance: public DataStructure
{
private:
    /** @brief Collection '.REFD' */
    /** Collection de vecteurs contenant les informations sur les matrices de masse, amortissement
        et rigidité mais également d’autres informations telles que la numérotation (NUME_DDL) 
        ou encore la liste d’interfaces dynamiques et statiques ayant servi au calcul produisant le concept*/
    JeveuxCollectionChar24       _refd;
    /** @brief Vecteur Jeveux '.INDI' */
    /** Cet objet définit l’indirection entre le numéro d’ordre des champs enregistrés et les objets 
        enregistrés dans  la collection .REFD */
    JeveuxVectorLong             _indi;
public:
    /**
     * @typedef DynamicResultsContainerPtr
     * @brief Pointeur intelligent vers un DynamicResultsContainerInstance
     */
    typedef boost::shared_ptr< DynamicResultsContainerInstance > DynamicResultsContainerPtr;

    /**
     * @brief Constructeur
     */
    DynamicResultsContainerInstance( std::string sd_type="SD_RESU_DYNA" ):
            DataStructure( sd_type , Permanent ),
            _refd( JeveuxCollectionChar24( getName() + ".REFD" ) ),
            _indi( JeveuxVectorLong( getName() + ".INDI" ) )
    {};
};

typedef boost::shared_ptr< DynamicResultsContainerInstance > DynamicResultsContainerPtr;

#endif /* DYNAMICRESULTSCONTAINER_H_ */
