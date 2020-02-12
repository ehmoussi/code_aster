#ifndef FORWARDGENERALIZEDMODERESULT_H_
#define FORWARDGENERALIZEDMODERESULT_H_

/**
 * @file ForwardGeneralizedModeResult.h
 * @brief Fichier entete de la classe ForwardGeneralizedModeResult
 * @author Nicolas Sellenet
 * @section LICENCE
 *   Copyright (C) 1991 - 2020  EDF R&D                www.code-aster.org
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

#include "astercxx.h"

class GeneralizedModeResultClass;
typedef boost::shared_ptr< GeneralizedModeResultClass > GeneralizedModeResultPtr;

/**
 * @class ForwardGeneralizedModeResultPtr
 * @brief Forward definition of GeneralizedModeResultPtr
 * @author Nicolas Sellenet
 */
class ForwardGeneralizedModeResultPtr {
  private:
    /** @brief Pointer to GeneralizedModeResultClass */
    GeneralizedModeResultPtr _ptr;
    bool _isSet;

  public:
    /**
     * @brief Constructor
     */
    ForwardGeneralizedModeResultPtr();

    /**
     * @brief Constructor
     */
    ForwardGeneralizedModeResultPtr( const GeneralizedModeResultPtr &ptr );

    void operator=( const GeneralizedModeResultPtr &ptr );

    GeneralizedModeResultPtr getPointer();

    bool isSet() const;

    void setPointer( const GeneralizedModeResultPtr &ptr );
};

#endif /* FORWARDGENERALIZEDMODERESULT_H_ */
