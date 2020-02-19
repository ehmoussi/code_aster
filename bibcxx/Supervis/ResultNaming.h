#ifndef RESULTNAMING_H_
#define RESULTNAMING_H_

/**
 * @file ResultNaming.h
 * @brief Implementation of automatic naming of jeveux objects.
 * @section LICENCE
 * Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
 * This file is part of code_aster.
 *
 * code_aster is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * code_aster is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with code_aster.  If not, see <http://www.gnu.org/licenses/>.

 * person_in_charge: mathieu.courtois@edf.fr
 */

#include <string>

class ResultNaming {
  public:
    // up to 4294967295 objects can be base 16 encoded on 8 chars.
    static long numberOfObjects;

    /**
     * @brief Initialize the counter.
     */
    static void initCounter( const long );

    /**
* @brief Static member that returns the current result name.
* @return Name for the current object that is being created.
*/
    static std::string getCurrentName();

    /**
     * @brief Static member that returns a new result name.
     * @return Name for the new object.
     */
    static std::string getNewResultName();
};

#endif /* RESULTNAMING_H_ */
