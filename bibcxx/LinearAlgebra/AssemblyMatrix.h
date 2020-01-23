#ifndef ASSEMBLYMATRIX_H_
#define ASSEMBLYMATRIX_H_

/**
 * @file AssemblyMatrix.h
 * @brief Fichier entete de la classe AssemblyMatrix
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

#include <list>
#include <stdexcept>

#include "aster_fort.h"
#include "astercxx.h"

#include "DataStructures/DataStructure.h"
#include "LinearAlgebra/ElementaryMatrix.h"
#include "Loads/ListOfLoads.h"
#include "MemoryManager/JeveuxCollection.h"
#include "MemoryManager/JeveuxVector.h"
#include "Supervis/CommandSyntax.h"
#include "Utilities/Tools.h"
#ifdef _HAVE_PETSC4PY
#if _HAVE_PETSC4PY == 1
#include <petscmat.h>
#endif
#endif

#include "Discretization/DOFNumbering.h"
#include "Discretization/ParallelDOFNumbering.h"
#include "Loads/PhysicalQuantity.h"
#include "Modeling/Model.h"

class BaseLinearSolverInstance;

/**
 * @class AssemblyMatrixInstance
 * @brief Classe template definissant une sd_matr_asse.
 *        Cette classe est volontairement succinte car on n'en connait pas encore l'usage
 * @author Nicolas Sellenet
 * @todo revoir le template pour prendre la grandeur en plus
 */
template < class ValueType, PhysicalQuantityEnum PhysicalQuantity >
class AssemblyMatrixInstance : public DataStructure {
  private:
    typedef boost::shared_ptr< ElementaryMatrixInstance< ValueType, PhysicalQuantity > >
        ElementaryMatrixPtr;
    /** @typedef std::list de KinematicsLoad */
    typedef std::list< KinematicsLoadPtr > ListKinematicsLoad;
    /** @typedef Iterateur sur une std::list de KinematicsLoad */
    typedef ListKinematicsLoad::iterator ListKinematicsLoadIter;

    /** @brief Objet Jeveux '.REFA' */
    JeveuxVectorChar24 _description;
    /** @brief Collection '.VALM' */
    JeveuxCollection< ValueType > _matrixValues;
    /** @brief Objet '.CONL' */
    JeveuxVectorDouble _scaleFactorLagrangian;
    /** @brief Objet Jeveux '.LIME' */
    JeveuxVectorChar24 _listOfElementaryMatrix;
    /** @brief Objet Jeveux '.VALF' */
    JeveuxVector< ValueType > _valf;
    /** @brief Objet Jeveux '.WALF' */
    JeveuxVector< ValueType > _walf;
    /** @brief Objet Jeveux '.UALF' */
    JeveuxVector< ValueType > _ualf;
    /** @brief Objet Jeveux '.PERM' */
    JeveuxVectorLong _perm;
    /** @brief Objet Jeveux '.DIGS' */
    JeveuxVector< ValueType > _digs;

    /** @brief Objet Jeveux '.CCID' */
    JeveuxVectorLong _ccid;
    /** @brief Objet Jeveux '.CCLL' */
    JeveuxVectorLong _ccll;
    /** @brief Objet Jeveux '.CCVA' */
    JeveuxVector< ValueType > _ccva;
    /** @brief Objet Jeveux '.CCII' */
    JeveuxVectorLong _ccii;

    /** @brief ElementaryMatrix sur lesquelles sera construit la matrice */
    std::vector< ElementaryMatrixPtr >  _elemMatrix;
    /** @brief Objet nume_ddl */
    BaseDOFNumberingPtr _dofNum;
    /** @brief La matrice est elle vide ? */
    bool _isEmpty;
    /** @brief La matrice est elle vide ? */
    bool _isFactorized;
    /** @brief Liste de charges cinematiques */
    ListOfLoadsPtr _listOfLoads;
    /** @brief Solver name (MUMPS or PETSc) */
    std::string _solverName;

    friend class BaseLinearSolverInstance;

  public:
    /**
     * @typedef AssemblyMatrixPtr
     * @brief Pointeur intelligent vers un AssemblyMatrix
     */
    typedef boost::shared_ptr< AssemblyMatrixInstance< ValueType, PhysicalQuantity > >
        AssemblyMatrixPtr;

    /**
     * @brief Constructeur
     */
    AssemblyMatrixInstance( const JeveuxMemory memType = Permanent );

    /**
     * @brief Constructeur
     */
    AssemblyMatrixInstance( const std::string &name );

    /**
     * @brief Destructeur
     */
    ~AssemblyMatrixInstance() {
#ifdef _DEBUG_CXX
        std::cout << "DEBUG: AssemblyMatrixInstance.destr: " << this->getName() << std::endl;
#endif
        if ( _description->exists() && ( _solverName == "MUMPS" || _solverName == "PETSC" ) ) {
            CALLO_DELETE_MATRIX( getName(), _solverName );
        }
    };

    /**
     * @brief Function d'ajout d'un chargement
     * @param Args... Liste d'arguments template
     */
    template < typename... Args > void addLoad( const Args &... a ) {
        _listOfLoads->addLoad( a... );
    };

    /**
     * @brief Methode permettant de definir les matrices elementaires
     * @param currentElemMatrix objet ElementaryMatrix
     */
    void appendElementaryMatrix( const ElementaryMatrixPtr &currentElemMatrix )
    {
        _elemMatrix.push_back( currentElemMatrix );
    };

    /**
     * @brief Assemblage de la matrice
     */
    bool build() ;

    /**
     * @brief Clear all ElementaryMatrixPtr
     */
    void clearElementaryMatrix()
    {
        _elemMatrix.clear();
    };

    /**
     * @brief Get the internal DOFNumbering
     * @return Internal DOFNumbering
     */
    BaseDOFNumberingPtr getDOFNumbering() const { return _dofNum; };

    /**
     * @brief Get model
     * @return Internal Model
     */
    ModelPtr getModel()
    {
        if( _dofNum != nullptr )
        {
            return _dofNum->getModel();
        }
        return ModelPtr( nullptr );
    };

    /**
     * @brief Get mesh
     * @return Internal mesh
     */
    BaseMeshPtr getMesh()
    {
        if( _dofNum != nullptr )
        {
            return _dofNum->getMesh();
        }
        return nullptr;
    };

    /**
     * @brief Get MaterialOnMesh
     * @return MaterialOnMesh of the first ElementaryMatrix (all others must be the same)
     */
    MaterialOnMeshPtr getMaterialOnMesh() const
    {
        if ( _elemMatrix.size() != 0 )
            return _elemMatrix[0]->getMaterialOnMesh();
        throw std::runtime_error( "No ElementaryMatrix in AssemblyMatrix" );
    };

    /**
     * @brief Get the number of defined ElementaryMatrix
     * @return size of vector containing ElementaryMatrix
     */
    int getNumberOfElementaryMatrix() const
    {
        return _elemMatrix.size();
    };

#ifdef _HAVE_PETSC4PY
#if _HAVE_PETSC4PY == 1
    /**
     * @brief Conversion to petsc4py
     * @return converted matrix
     */
    Mat toPetsc4py() ;
#endif
#endif

    /**
     * @brief Methode permettant de savoir si la matrice est vide
     * @return true si vide
     */
    bool isEmpty() const { return ( !_description->exists() ); };

    /**
     * @brief Methode permettant de definir la numerotation
     * @param currentNum objet DOFNumbering
     */
    void setDOFNumbering( const BaseDOFNumberingPtr currentNum ) { _dofNum = currentNum; };

/**
 * @brief Methode permettant de definir la numerotation
 * @param currentNum objet ParallelDOFNumbering
 */
// #ifdef _USE_MPI
//         void setDOFNumbering( const ParallelDOFNumberingPtr& currentNum )
//         {
//             _dofNum = currentNum;
//         };
// #endif /* _USE_MPI */

    /**
     * @brief Methode permettant de definir la liste de chargement
     * @param lLoads objet de type ListOfLoadsPtr
     */
    void setListOfLoads( const ListOfLoadsPtr &lLoads ) { _listOfLoads = lLoads; };

    /**
     * @brief Function to set the solver name (MUMS or PETSc)
     * @param sName name of solver ("MUMPS" or "PETSC")
     * @todo delete this function and the attribute _solverName
     */
    void setSolverName( const std::string &sName ) { _solverName = sName; };
};

/** @typedef Definition d'une matrice assemblee de double */
template class AssemblyMatrixInstance< double, Displacement >;
typedef AssemblyMatrixInstance< double, Displacement > AssemblyMatrixDisplacementDoubleInstance;
/** @typedef Definition d'une matrice assemblee de complexe */
typedef AssemblyMatrixInstance< DoubleComplex, Displacement >
    AssemblyMatrixDisplacementComplexInstance;

/** @typedef Definition d'une matrice assemblee de double temperature */
template class AssemblyMatrixInstance< double, Temperature >;
typedef AssemblyMatrixInstance< double, Temperature > AssemblyMatrixTemperatureDoubleInstance;

/** @typedef Definition d'une matrice assemblee de double pression */
template class AssemblyMatrixInstance< double, Pressure >;
typedef AssemblyMatrixInstance< double, Pressure > AssemblyMatrixPressureDoubleInstance;

/** @typedef Definition d'une matrice assemblee de DoubleComplex temperature */
template class AssemblyMatrixInstance< DoubleComplex, Temperature >;
typedef AssemblyMatrixInstance< DoubleComplex, Temperature >
    AssemblyMatrixTemperatureComplexInstance;

/** @typedef Definition d'une matrice assemblee de DoubleComplex pression */
template class AssemblyMatrixInstance< DoubleComplex, Pressure >;
typedef AssemblyMatrixInstance< DoubleComplex, Pressure > AssemblyMatrixPressureComplexInstance;

typedef boost::shared_ptr< AssemblyMatrixDisplacementDoubleInstance >
    AssemblyMatrixDisplacementDoublePtr;
typedef boost::shared_ptr< AssemblyMatrixDisplacementComplexInstance >
    AssemblyMatrixDisplacementComplexPtr;
typedef boost::shared_ptr< AssemblyMatrixTemperatureDoubleInstance >
    AssemblyMatrixTemperatureDoublePtr;
typedef boost::shared_ptr< AssemblyMatrixTemperatureComplexInstance >
    AssemblyMatrixTemperatureComplexPtr;
typedef boost::shared_ptr< AssemblyMatrixPressureDoubleInstance > AssemblyMatrixPressureDoublePtr;
typedef boost::shared_ptr< AssemblyMatrixPressureComplexInstance > AssemblyMatrixPressureComplexPtr;

template < class ValueType, PhysicalQuantityEnum PhysicalQuantity >
AssemblyMatrixInstance< ValueType, PhysicalQuantity >::AssemblyMatrixInstance(
    const JeveuxMemory memType )
    : DataStructure( "MATR_ASSE_" + std::string( PhysicalQuantityNames[PhysicalQuantity] ) +
                         ( typeid( ValueType ) == typeid(double)? "_R" : "_C" ),
                     memType, 19 ),
      _description( JeveuxVectorChar24( getName() + ".REFA" ) ),
      _matrixValues( JeveuxCollection< ValueType >( getName() + ".VALM" ) ),
      _scaleFactorLagrangian( JeveuxVectorDouble( getName() + ".CONL" ) ),
      _listOfElementaryMatrix( JeveuxVectorChar24( getName() + ".LIME" ) ),
      _valf( JeveuxVector< ValueType >( getName() + ".VALF" ) ),
      _walf( JeveuxVector< ValueType >( getName() + ".WALF" ) ),
      _ualf( JeveuxVector< ValueType >( getName() + ".UALF" ) ),
      _perm( JeveuxVectorLong( getName() + ".PERM" ) ),
      _digs( JeveuxVector< ValueType >( getName() + ".DIGS" ) ),
      _ccid( JeveuxVectorLong( getName() + ".CCID" ) ),
      _ccll( JeveuxVectorLong( getName() + ".CCLL" ) ),
      _ccva( JeveuxVector< ValueType >( getName() + ".CCVA" ) ),
      _ccii( JeveuxVectorLong( getName() + ".CCII" ) ), _isEmpty( true ), _isFactorized( false ),
      _listOfLoads( ListOfLoadsPtr( new ListOfLoadsInstance( memType ) ) ){};

template < class ValueType, PhysicalQuantityEnum PhysicalQuantity >
AssemblyMatrixInstance< ValueType, PhysicalQuantity >::AssemblyMatrixInstance(
    const std::string &name )
    : DataStructure( name, 19, "MATR_ASSE_" +
                                   std::string( PhysicalQuantityNames[PhysicalQuantity] ) +
                                   ( typeid( ValueType ) == typeid(double)? "_R" : "_C" ) ),
      _description( JeveuxVectorChar24( getName() + ".REFA" ) ),
      _matrixValues( JeveuxCollection< ValueType >( getName() + ".VALM" ) ),
      _scaleFactorLagrangian( JeveuxVectorDouble( getName() + ".CONL" ) ),
      _listOfElementaryMatrix( JeveuxVectorChar24( getName() + ".LIME" ) ),
      _valf( JeveuxVector< ValueType >( getName() + ".VALF" ) ),
      _walf( JeveuxVector< ValueType >( getName() + ".WALF" ) ),
      _ualf( JeveuxVector< ValueType >( getName() + ".UALF" ) ),
      _perm( JeveuxVectorLong( getName() + ".PERM" ) ),
      _digs( JeveuxVector< ValueType >( getName() + ".DIGS" ) ),
      _ccid( JeveuxVectorLong( getName() + ".CCID" ) ),
      _ccll( JeveuxVectorLong( getName() + ".CCLL" ) ),
      _ccva( JeveuxVector< ValueType >( getName() + ".CCVA" ) ),
      _ccii( JeveuxVectorLong( getName() + ".CCII" ) ), _isEmpty( true ), _isFactorized( false ),
      _listOfLoads( ListOfLoadsPtr( new ListOfLoadsInstance() ) ){};

template < class ValueType, PhysicalQuantityEnum PhysicalQuantity >
bool AssemblyMatrixInstance< ValueType, PhysicalQuantity >::build() {
    if ( _dofNum->isEmpty() )
        throw std::runtime_error( "Numbering is empty" );

    if ( getNumberOfElementaryMatrix() == 0 )
        throw std::runtime_error( "Elementary matrix is empty" );

    ASTERINTEGER typscal = 2;
    if ( typeid( ValueType ) == typeid(double) )
        typscal = 1;
    VectorString names;
    for ( const auto elemIt : _elemMatrix )
        names.push_back( elemIt->getName() );

    char *tabNames = vectorStringAsFStrArray( names, 8 );

    std::string base( "G" );
    std::string blanc( " " );
    std::string cumul( "ZERO" );
    if ( _listOfLoads->isEmpty() && _listOfLoads->size() != 0 )
        _listOfLoads->build();
    ASTERINTEGER nbMatrElem = 1;
    CALL_ASMATR( &nbMatrElem, tabNames, blanc.c_str(), _dofNum->getName().c_str(),
                 _listOfLoads->getName().c_str(), cumul.c_str(), base.c_str(), &typscal,
                 getName().c_str() );
    _isEmpty = false;
    FreeStr( tabNames );

    return true;
};

#ifdef _HAVE_PETSC4PY
#if _HAVE_PETSC4PY == 1

template < class ValueType, PhysicalQuantityEnum PhysicalQuantity >
Mat
AssemblyMatrixInstance< ValueType, PhysicalQuantity >::toPetsc4py() {
    Mat myMat;
    PetscErrorCode ierr;

    if ( _isEmpty )
        throw std::runtime_error( "Assembly matrix is empty" );
    if ( getType() != "MATR_ASSE_DEPL_R" )
        throw std::runtime_error( "Not yet implemented" );

    CALLO_MATASS2PETSC( getName(), &myMat, &ierr );

    return myMat;
};
#endif
#endif

#endif /* ASSEMBLYMATRIX_H_ */
