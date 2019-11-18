#ifndef FORWARDGENERALIZEDDOFNUMBERING_H_
#define FORWARDGENERALIZEDDOFNUMBERING_H_

/**
 * @file ForwardGeneralizedDOFNumbering.h
 * @brief Fichier entete de la classe ForwardGeneralizedDOFNumbering
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

#include "astercxx.h"

class GeneralizedDOFNumberingInstance;
typedef boost::shared_ptr< GeneralizedDOFNumberingInstance > GeneralizedDOFNumberingPtr;

/**
 * @class ForwardGeneralizedDOFNumberingPtr
 * @brief Forward definition of GeneralizedDOFNumberingPtr
 * @author Nicolas Sellenet
 */
class ForwardGeneralizedDOFNumberingPtr {
  private:
    /** @brief Pointer to GeneralizedDOFNumberingInstance */
    GeneralizedDOFNumberingPtr _ptr;
    bool _isSet;

  public:
    /**
     * @brief Constructor
     */
    ForwardGeneralizedDOFNumberingPtr();

    /**
     * @brief Constructor
     */
    ForwardGeneralizedDOFNumberingPtr( const GeneralizedDOFNumberingPtr &ptr );

    void operator=( const GeneralizedDOFNumberingPtr &ptr );

    GeneralizedDOFNumberingPtr getPointer() ;

    bool isSet() const;

    void setPointer( const GeneralizedDOFNumberingPtr &ptr );
};

#endif /* FORWARDGENERALIZEDDOFNUMBERING_H_ */
