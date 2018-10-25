#ifndef CONTACTDEFINITION_H_
#define CONTACTDEFINITION_H_

/**
 * @file ContactDefinition.h
 * @brief Fichier entete de la class ContactDefinition
 * @author Nicolas Sellenet
 * @section LICENCE
 *   Copyright (C) 1991 - 2018  EDF R&D                www.code-aster.org
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

#include "Utilities/CapyConvertibleValue.h"
#include <stdexcept>
#include <list>
#include <string>
#include "astercxx.h"
#include "Modeling/Model.h"
#include "MemoryManager/JeveuxVector.h"
#include "DataStructures/DataStructure.h"
#include "Supervis/CommandSyntax.h"
#include "Supervis/ResultNaming.h"

class ContactDefinitionInstance : public DataStructure {
  private:
    /** @brief La SD est-elle vide ? */
    bool _isEmpty;
    /** @brief Modele support */
    ModelPtr _supportModel;

  public:
    /**
    * @typedef ContactDefinitionPt
    * @brief Pointeur intelligent vers un ContactDefinition
    */
    typedef boost::shared_ptr< ContactDefinitionInstance > ContactDefinitionPtr;
    /**
     * @brief Constructeur
     */
    ContactDefinitionInstance() : ContactDefinitionInstance( ResultNaming::getNewResultName() ){};

    /**
     * @brief Constructeur
     */
    ContactDefinitionInstance( const std::string name )
        : DataStructure( name, 8, "CHAR_CONTACT" ), _supportModel( ModelPtr() ), _isEmpty( true ){};
};

/**
* @typedef ContactDefinitionPt
* @brief Pointeur intelligent vers un ContactDefinition
*/
typedef boost::shared_ptr< ContactDefinitionInstance > ContactDefinitionPtr;

#endif /* CONTACTDEFINITION_H_ */
