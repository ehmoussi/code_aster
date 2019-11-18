
#include "astercxx.h"

#ifdef _USE_MPI

#ifndef COMMUNICATIONGRAPH_H_
#define COMMUNICATIONGRAPH_H_

/**
 * @file CommunicationGraph.h
 * @brief Header of CommunicationGraph class
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

#include "aster_fort.h"
#include "MemoryManager/JeveuxVector.h"

class CommunicationGraph {
  private:
    /** @brief Graph */
    JeveuxVectorLong _graph;

  public:
    CommunicationGraph( const std::string &, const JeveuxVectorLong & );
};

/**
 * @typedef CommunicationGraphPtr
 * @brief Pointeur intelligent vers un CommunicationGraph
 */
typedef boost::shared_ptr< CommunicationGraph > CommunicationGraphPtr;

#endif /* COMMUNICATIONGRAPH_H_ */

#endif /* _USE_MPI */
