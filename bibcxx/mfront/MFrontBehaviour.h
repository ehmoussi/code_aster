/* -------------------------------------------------------------------- */
/* Copyright (C) 1991 - 2017 - EDF R&D - www.code-aster.org             */
/* This file is part of code_aster.                                     */
/*                                                                      */
/* code_aster is free software: you can redistribute it and/or modify   */
/* it under the terms of the GNU General Public License as published by */
/* the Free Software Foundation, either version 3 of the License, or    */
/* (at your option) any later version.                                  */
/*                                                                      */
/* code_aster is distributed in the hope that it will be useful,        */
/* but WITHOUT ANY WARRANTY; without even the implied warranty of       */
/* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the        */
/* GNU General Public License for more details.                         */
/*                                                                      */
/* You should have received a copy of the GNU General Public License    */
/* along with code_aster.  If not, see <http://www.gnu.org/licenses/>.  */
/* -------------------------------------------------------------------- */

#ifndef MFRONTBEHAVIOUR_H_
#define MFRONTBEHAVIOUR_H_

/* person_in_charge: mathieu.courtois@edf.fr */

#ifdef __cplusplus

#include <string>
#include <vector>

#include "TFEL/System/ExternalLibraryManager.hxx"

/**
 * \brief A simplified wrapper to a MFront behaviour to request
 *        some informations.
 */
class MFrontBehaviour
{
    public:
        MFrontBehaviour(std::string hyp, std::string lib, std::string behav);
        /**
         * \brief Return a vector of the properties names
         */
        std::vector<std::string> getMaterialPropertiesNames();
        ~MFrontBehaviour();

    private:
        //! hypothesis
        const std::string _hypothesis;
        //! library
        const std::string _libname;
        //! behaviour
            const std::string _bname;
        //! names of the material properties
        std::vector<std::string> _mpnames;
        //! indicator to compute properties names only once
        bool _mpnames_computed;

        /**
         * \brief fill the _mpnames attribute
         */
        void fillMaterialPropertiesNames();
};

/**
 * \brief Convert a MFront parameter name to a Code_Aster one
 *        Example: 'name[i]' into 'name_i'
 */
std::string toAsterParameter(const std::string &);

/**
 * \brief Apply toAsterParameter to the elements of a vector
 * \return a new vector
 */
std::vector<std::string> toAsterParameterVect(const std::vector<std::string> &);

/**
 * \brief Convert a vector of strings into a char** and size
 *        Warning: each char* must be freed.
 * \param[in] svect : vector of strings
 * \param[out] size : number of elements in the vector
 * \return char**
 */
char** vectorOfStringsAsCharArray(const std::vector<std::string> &, unsigned int *);

extern "C"
{
#endif // __cplusplus

/**
 * \brief Return an array of strings of the properties names
 * @param hypothesis
 * @param library
 * @param function
 * @param size      Size of the array, number of properties
 */
char** getMaterialPropertiesNames(const char*, const char*, const char*,
                                  unsigned int *);

/**
 * \brief Return an array of strings of the properties names
 *        using the default library name and Tridimensional hypothesis
 * @param behaviour name
 * @param size      Size of the array, number of properties
 */
char** getTridimMaterialPropertiesNames(const char*,
                                        unsigned int *);

#ifdef __cplusplus
}
#endif // __cplusplus

#endif // MFRONTBEHAVIOUR_H_
