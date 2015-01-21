#ifndef ELEMENTARYLOAD_H_
#define ELEMENTARYLOAD_H_

/**
 * @file ElementaryLoad.h
 * @brief Fichier entete de la classe FieldOnNodes
 * @author Natacha Bereux
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

#include "Modelisations/Model.h"
#include "DataFields/PCFieldOnMesh.h"
#include "aster.h"

/**
 * @class ElementaryLoad
 * @brief Charge élémentaire
 * @author Natacha Bereux
 */
template<class ValueType>
class ElementaryLoad
{
    private:
        /** @brief Nom du type de charge (DDL_IMPO, PRES_REP) */
        string  _type;
        /** @brief Nom de la composante de la grandeur dontla valeur est
                   imposée, ex : "DX", "PRES" */
        string   _name;
        /** @brief Description de parametre, ex : "Pressure" */
        string   _description;
        /** @brief Valeur du parametre (double, complex, fonction...) */
        ValueType _value;

    public:
        /**
         * @brief Constructeur
         * @param name Nom de la composante fixée  (ex : "DX")
         * @param description Description libre
         */
        ElementaryLoad(string type, string name, string description = ""):_type( type ),
                                                                          _name( name ),
                                                                          _description( description )
        {};

        /**
         * @brief Récupération du type de contrainte
         * @return le nom Aster du mot-clé facteur définissant le type de contrainte 
         */
        const string& getType() const
        {
            return _type;
        };

        /**
         * @brief Recuperation du nom de la composante fixée
         * @return le nom Aster du parametre
         */
        const string& getName() const
        {
            return _name;
        };

        /**
         * @brief Recuperation de la valeur du parametre
         * @return la valeur du parametre
         */
        const ValueType & getValue() const

        {
            return _value;
        };

        /**
         * @brief Fonction servant a fixer la valeur du parametre
         * @param currentValue valeur donnee par l'utilisateur
         */
        void setValue(ValueType & currentValue)
        {
            _value = currentValue;
        };
};

/** @typedef Definition d'une charge elementaire de double */
typedef class ElementaryLoad<double> ElementaryLoadDouble;

/**
 * @class DisplacementLoad
 * @brief Cette classe template permet de definir une charge elementaire sur un DEPL
 * @author Natacha Bereux
 */
template<class ValueType>
class DisplacementLoad: public ElementaryLoad<ValueType>
{
    public:
        /**
         * @brief Constructeur
         */
        DisplacementLoad<ValueType>(string name):
                ElementaryLoad<ValueType>( "DDL_IMPO", name, "Imposed displacement" )
        {};
};

/**
 * @class FieldOnNodesInstance
 * @brief Cette classe template permet de definir un champ aux noeuds Aster
 * @author Natacha Bereux
 */
template<class ValueType>
class PressureLoad: public ElementaryLoad<ValueType>
{
    public:
        /**
         * @brief Constructeur
         */
        PressureLoad<ValueType>(): ElementaryLoad<ValueType>( "PRES_REP", "PRES", "Pressure" )
        {};
};

#endif /* ELEMENTARYLOAD_H_ */
