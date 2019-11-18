#ifndef GENERICCONTEXTUPDATER_H_
#define GENERICCONTEXTUPDATER_H_

/**
 * @file GenericContextUpdater.h
 * @brief Fichier entete de la classe GenericContextUpdater
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

/**
 * @class GenericContextUpdater
 * @brief Template class of what should be the function which update a context of a algorithm
 * @author Nicolas Sellenet
 */
template < typename CurrentStepperIter, typename CurrentContext >
void updateContextFromStepper( const CurrentStepperIter &step, CurrentContext &context );

#endif /* GENERICCONTEXTUPDATER_H_ */
