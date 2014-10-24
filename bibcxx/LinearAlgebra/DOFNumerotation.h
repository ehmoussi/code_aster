#ifndef DOFNUMEROTATION_H_
#define DOFNUMEROTATION_H_

/* person_in_charge: nicolas.sellenet at edf.fr */

#include "DataStructure/DataStructure.h"
#include "LinearAlgebra/LinearSolver.h"
#include "MemoryManager/JeveuxVector.h"
#include "Modelisations/Model.h"
#include "LinearAlgebra/ElementaryMatrix.h"
#include "Loads/MechanicalLoad.h"

/**
* class DOFNumerotationInstance
*   Class definissant un nume_ddl
*   Cette classe est volontairement succinte car on n'en connait pas encore l'usage
* @author Nicolas Sellenet
*/
class DOFNumerotationInstance: public DataStructure
{
    private:
        // !!! Classe succinte car on ne sait pas comment elle sera utiliser !!!
        // Objet Jeveux '.NSLV'
        JeveuxVectorChar24 _nameOfSolverDataStructure;
        // Modele support
        Model              _supportModel;
        // Matrices elementaires
        ElementaryMatrix   _supportMatrix;
        // Conditions aux limites
        MechanicalLoad     _load;
        // Solveur lineaire
        LinearSolver       _linearSolver;
        bool               _isEmpty;

    public:
        /**
        * Constructeur
        */
        DOFNumerotationInstance();

        /**
        * Destructeur
        */
        ~DOFNumerotationInstance()
        {};

        /**
        * Methode permettant d'ajouter un chargement
        * @param currentLoad objet MechanicalLoad
        */
        void addLoad( const MechanicalLoad& currentLoad )
        {
            throw "Not yet implemented";
        };

        /**
        * Determination de la numerotation
        */
        bool computeNumerotation();

        /**
        * Methode permettant de definir les matrices elementaires
        * @param currentMatrix objet ElementaryMatrix
        */
        void setElementaryMatrix( const ElementaryMatrix& currentMatrix )
        {
            if ( ! _supportModel.isEmpty() )
                throw "It is not allowed to defined Model and ElementaryMatrix together";
            _supportMatrix = currentMatrix;
        };

        /**
        * Methode permettant de definir le solveur
        * @param currentModel Model support de la numerotation
        */
        void setLinearSolver( const LinearSolver& currentSolver )
        {
            if ( ! _isEmpty )
                throw "It is too late to set the linear solver";
            _linearSolver = currentSolver;
        };

        /**
        * Methode permettant de definir le modele support
        * @param currentModel Model support de la numerotation
        */
        void setSupportModel( const Model& currentModel )
        {
            if ( ! _supportMatrix.isEmpty() )
                throw "It is not allowed to defined Model and ElementaryMatrix together";
            _supportModel = currentModel;
        };
};

/**
* class DOFNumerotation
*   Enveloppe d'un pointeur intelligent vers un DOFNumerotation
* @author Nicolas Sellenet
*/
class DOFNumerotation
{
    public:
        typedef boost::shared_ptr< DOFNumerotationInstance > DOFNumerotationPtr;

    private:
        DOFNumerotationPtr _dOFNumerotationPtr;

    public:
        DOFNumerotation(bool initialisation = true): _dOFNumerotationPtr()
        {
            if ( initialisation == true )
                _dOFNumerotationPtr = DOFNumerotationPtr( new DOFNumerotationInstance() );
        };

        ~DOFNumerotation()
        {};

        DOFNumerotation& operator=(const DOFNumerotation& tmp)
        {
            _dOFNumerotationPtr = tmp._dOFNumerotationPtr;
            return *this;
        };

        const DOFNumerotationPtr& operator->() const
        {
            return _dOFNumerotationPtr;
        };

        DOFNumerotationInstance& operator*(void) const
        {
            return *_dOFNumerotationPtr;
        };

        bool isEmpty() const
        {
            if ( _dOFNumerotationPtr.use_count() == 0 ) return true;
            return false;
        };
};

#endif /* DOFNUMEROTATION_H_ */
