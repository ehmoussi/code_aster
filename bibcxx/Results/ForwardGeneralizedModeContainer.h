#ifndef FORWARDGENERALIZEDMODECONTAINER_H_
#define FORWARDGENERALIZEDMODECONTAINER_H_

/**
 * @file ForwardGeneralizedModeContainer.h
 * @brief Fichier entete de la classe ForwardGeneralizedModeContainer
 * @author Nicolas Sellenet
 * @section LICENCE
 *   Copyright (C) 1991 - 2019  EDF R&D                www.code-aster.org
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

class GeneralizedModeContainerInstance;
typedef boost::shared_ptr< GeneralizedModeContainerInstance > GeneralizedModeContainerPtr;

/**
 * @class ForwardGeneralizedModeContainerPtr
 * @brief Forward definition of GeneralizedModeContainerPtr
 * @author Nicolas Sellenet
 */
class ForwardGeneralizedModeContainerPtr {
  private:
    /** @brief Pointer to GeneralizedModeContainerInstance */
    GeneralizedModeContainerPtr _ptr;
    bool _isSet;

  public:
    /**
     * @brief Constructor
     */
    ForwardGeneralizedModeContainerPtr();

    /**
     * @brief Constructor
     */
    ForwardGeneralizedModeContainerPtr( const GeneralizedModeContainerPtr &ptr );

    void operator=( const GeneralizedModeContainerPtr &ptr );

    GeneralizedModeContainerPtr getPointer();

    bool isSet() const;

    void setPointer( const GeneralizedModeContainerPtr &ptr );
};

#endif /* FORWARDGENERALIZEDMODECONTAINER_H_ */
