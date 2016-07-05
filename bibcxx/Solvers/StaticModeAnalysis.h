#ifndef STATICMODEANALYSIS_H_
#define STATICMODEANALYSIS_H_

/**
 * @file StaticModeAnalysis.h
 * @brief Definition of the static mode solver
 * @author Guillaume Drouet
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

/* person_in_charge: guillaume.drouet at edf.fr */
#include "astercxx.h"

#include "LinearAlgebra/AssemblyMatrix.h"
#include "LinearAlgebra/LinearSolver.h"
#include "Solvers/GenericSolver.h"
#include "Utilities/GenericParameter.h"


/**
 @brief the StaticModeAnalysis class is used to perform 
 a static mode analysis from ....
*/

class StaticModeAnalysisInstance: public GenericSolver
{
    protected:
        /** @brief Mass Matrix */
        AssemblyMatrixDoublePtr    _MassMatrix;          
        /** @brief Stiffness Matrix */
        AssemblyMatrixDoublePtr    _StiffMatrix; 
        /** @brief Solveur lineaire */
        LinearSolverPtr   _linearSolver;
        /** @brief factor keyword composant description */
        GenParam _cmp;
        GenParam _loc;
    public:
        /**
         * @brief Constructeur
         */
        StaticModeAnalysisInstance():_cmp("TOUT_CMP", true),
                                     _loc("TOUT", true)
        {};
        
        /**
         * @brief Set GROUP_NO
         * @param listloc wanted goroups of nodes
         */
        void setAllLoc()
        {
            _loc = GenParam("TOUT", "OUI", true);
        };
        
        /**
         * @brief Set GROUP_NO
         * @param listloc wanted goroups of nodes
         */
        void setAllCmp()
        {
            _cmp = GenParam("TOUT_CMP", "OUI", true);
        };
        
         /**
         * @brief Set GROUP_NO
         * @param listloc wanted goroups of nodes
         */
        void WantedGrno(const std::vector<std::string> listloc)
        {
            _loc = GenParam("GROUP_NO", listloc, true);
        };
        
        /**
         * @brief Set AVEC_CMP
         * @param listcmp wanted coponent
         */
        void Wantedcmp(const std::vector<std::string> listcmp)
        {
            _cmp = GenParam("AVEC_CMP", listcmp, true);
        };

        /**
         * @brief Set SANS_CMP
         * @param listcmp unwanted coponent
         */
        void Unwantedcmp(const std::vector<std::string> listcmp)
        {
            _cmp = GenParam("SANS_CMP", listcmp, true);
        };
        
        /**
         * @brief Lancement de la resolution en appelant op0093 
         */
        virtual ResultsContainerPtr execute()= 0;
        
         /**
         * @brief Methode permettant de definir la matrice de masse
         * @param currentMatrix Matrice de masse
         */
        void setMassMatrix( const AssemblyMatrixDoublePtr& currentMatrix )
        {
            _MassMatrix = currentMatrix;
        };

        /**
         * @brief Methode permettant de definir la matrice de rigidite
         * @param currentMatrix Matrice de masse
         */
        void setStiffMatrix( const AssemblyMatrixDoublePtr& currentMatrix )
        {
            _StiffMatrix = currentMatrix;
        };
        
        /**
         * @brief Methode permettant de definir le solveur lineaire
         * @param currentSolver Solveur lineaire
         */
        void setLinearSolver( const LinearSolverPtr& currentSolver )
        {
            _linearSolver = currentSolver;
        };
};

class StaticModeDeplInstance: public StaticModeAnalysisInstance
{
    protected:
       
        
    public:
        /**
         * @brief Constructeur
         */
        StaticModeDeplInstance()
        {};

       
        /**
         * @brief Lancement de la resolution en appelant op0093 
         */
        ResultsContainerPtr execute() throw ( std::runtime_error );
};

class StaticModeForcInstance: public StaticModeAnalysisInstance 
{
    protected:
        
    public:
        /**
         * @brief Constructeur
         */
        StaticModeForcInstance()
        {};

        
        /**
         * @brief Lancement de la resolution en appelant op0093 
         */
        ResultsContainerPtr execute() throw ( std::runtime_error );
};

class StaticModePseudoInstance: public StaticModeAnalysisInstance 
{
    protected:
        /** @brief keyword NOM_DIR description */
        GenParam _dirname;
        
    public:
        /**
         * @brief Constructeur
         */
        StaticModePseudoInstance(): _dirname("NOM_DIR",false)
        {};
        
        
        /**
         * @brief Setdir
         * @param dir wanted direction
         */
        void WantedDir(const std::vector<double> dir)
        {
            _loc = GenParam("DIRECTION", dir, true);
        };

        /**
         * @brief Set axe
         * @param listaxe wanted axes
         */
        void WantedAxe(const std::vector<std::string> listaxe)
        {
            _loc = GenParam("AXE", listaxe, true);
        };

        /**
         * @brief Set dirname
         * @param name the Wanted_dir
         */
        void setDirname(const std::string dirname)
        {
            _dirname = GenParam("NOM_DIR", dirname, false);
        };
        
        
        /**
         * @brief Lancement de la resolution en appelant op0093 
         */
        ResultsContainerPtr execute() throw ( std::runtime_error );
};

class StaticModeInterfInstance: public StaticModeAnalysisInstance 
{
    protected:
        /** @brief keyword diranme description */
        GenParam _shift;
        GenParam _nbmod;
    public:
        /**
         * @brief Constructeur
         */
        StaticModeInterfInstance(): _nbmod("NB_MODE", 1, true),
                                  _shift("SHIFT", 1.0,true)
        {};

        /**
         * @brief Set dirname
         * @param name the Wanted_dir
         */
        void setNbmod(const int nb )
        {
            _nbmod = GenParam("NB_MODE", nb, true);
        };
        
        /**
         * @brief Set dirname
         * @param name the Wanted_dir
         */
        void setShift(const double shift)
        {
            _shift = GenParam("SHIFT", shift, true);
        };   
             
        /**
         * @brief Lancement de la resolution en appelant op0093 
         */
        ResultsContainerPtr execute() throw ( std::runtime_error );
};
/**
 * @typedef StaticNonLinearAnalysisPtr
 * @brief Enveloppe d'un pointeur intelligent vers un StaticModeAnalysisInstance
 */
typedef boost::shared_ptr< StaticModeDeplInstance > StaticModeDeplPtr; 
typedef boost::shared_ptr< StaticModeForcInstance > StaticModeForcPtr;
typedef boost::shared_ptr< StaticModePseudoInstance > StaticModePseudoPtr;
typedef boost::shared_ptr< StaticModeInterfInstance > StaticModeInterfPtr;

#endif /* STATICMODEANALYSIS_H_ */
