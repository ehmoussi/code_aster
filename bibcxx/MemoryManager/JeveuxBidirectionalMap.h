#ifndef JEVEUXBIDIRECTIONALMAP_H_
#define JEVEUXBIDIRECTIONALMAP_H_

/**
 * @file JeveuxBidirectionalMap.h
 * @brief Fichier entete de la classe JeveuxBidirectionnalMap
 * @author Nicolas Sellenet
 * @section LICENCE
 *   Copyright (C) 1991 - 2014  EDF R&D                www.code-aster.org
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

/* person_in_charge: nicolas.sellenet at edf.fr */

#include "astercxx.h"

/**
 * @class JeveuxBidirectionalMapInstance
 * @brief Equivalent du pointeur de nom dans Jeveux
 * @author Nicolas Sellenet
 */
class JeveuxBidirectionalMapInstance
{
    private:
        /** @brief Nom Jeveux de l'objet */
        std::string _jeveuxName;

    public:
        /**
         * @brief Constructeur
         * @param name Nom Jeveux de l'objet
         */
        JeveuxBidirectionalMapInstance( std::string name ): _jeveuxName( name )
        {};

        /**
         * @brief Recuperation de la chaine correspondante a l'entier
         * @param elementNumber Numero de l'element demande
         * @return Chaine de caractere correspondante
         */
        std::string findStringOfElement( long elementNumber );

        /**
         * @brief Recuperation de l'entier correspondant a une chaine
         * @param elementName Chaine recherchee
         * @return Entier correspondant
         */
        long findIntegerOfElement( std::string elementName );
};

/**
 * class JeveuxBidirectionalMap
 *   Enveloppe d'un pointeur intelligent vers un JeveuxBidirectionalMapInstance
 * @author Nicolas Sellenet
 */
class JeveuxBidirectionalMap
{
    public:
        typedef boost::shared_ptr< JeveuxBidirectionalMapInstance > JeveuxBidirectionalMapPtr;

    private:
        JeveuxBidirectionalMapPtr _jeveuxBidirectionalMapPtr;

    public:
        JeveuxBidirectionalMap( std::string nom ):
            _jeveuxBidirectionalMapPtr( new JeveuxBidirectionalMapInstance (nom) )
        {};

        ~JeveuxBidirectionalMap()
        {};

        JeveuxBidirectionalMap& operator=(const JeveuxBidirectionalMap& tmp)
        {
            _jeveuxBidirectionalMapPtr = tmp._jeveuxBidirectionalMapPtr;
            return *this;
        };

        const JeveuxBidirectionalMapPtr& operator->(void) const
        {
            return _jeveuxBidirectionalMapPtr;
        };

        bool isEmpty() const
        {
            if ( _jeveuxBidirectionalMapPtr.use_count() == 0 ) return true;
            return false;
        };
};

#endif /* JEVEUXBIDIRECTIONALMAP_H_ */
