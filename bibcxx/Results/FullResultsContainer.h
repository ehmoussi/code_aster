#ifndef FULLRESULTSCONTAINER_H_
#define FULLRESULTSCONTAINER_H_

/**
 * @file FullResultsContainer.h
 * @brief Fichier entete de la classe FullResultsContainer
 * @author Natacha Béreux
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

#include "astercxx.h"

#include "Results/DynamicResultsIndexing.h"
#include "Results/ResultsContainer.h"
#include "Discretization/DOFNumbering.h"
#include "Supervis/ResultNaming.h"

/**
 * @class FullResultsContainerInstance
 * @brief Cette classe correspond à un sd_dyna_phys
 * @author Natacha Béreux
 */
class FullResultsContainerInstance : public ResultsContainerInstance {
  protected:
    /** @brief indexage des résultats de calcul dynamiques */
    DynamicResultsIndexingPtr _index;
    /** @brief the DOFNumbering */
    DOFNumberingPtr _dofNum;

  public:
    /**
     * @brief Constructeur
     * @todo  Ajouter les objets Jeveux de la SD
     */
    FullResultsContainerInstance( const std::string &name, const std::string &resuTyp )
        : ResultsContainerInstance( name, resuTyp ),
          _index( new DynamicResultsIndexingInstance( name, resuTyp ) ), _dofNum( nullptr ){};

    FullResultsContainerInstance( const std::string &resuTyp )
        : FullResultsContainerInstance( ResultNaming::getNewResultName(), resuTyp ){};

    DOFNumberingPtr getDOFNumbering() const
    {
        return _dofNum;
    };

    bool printMedFile( std::string fileName ) const {
        return ResultsContainerInstance::printMedFile( fileName );
    };

    bool setDOFNumbering( const DOFNumberingPtr &dofNum ) {
        if ( dofNum != nullptr ) {
            _dofNum = dofNum;
            if ( _dofNum->getModel() != nullptr )
                _mesh = _dofNum->getModel()->getMesh();
            _fieldBuidler.addFieldOnNodesDescription( _dofNum->getFieldOnNodesDescription() );
            return true;
        }
        return false;
    };
};

/**
 * @typedef FullResultsContainerPtr
 * @brief Pointeur intelligent vers un FullResultsContainerInstance
 */
typedef boost::shared_ptr< FullResultsContainerInstance > FullResultsContainerPtr;

#endif /* FULLRESULTSCONTAINER_H_ */
