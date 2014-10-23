#ifndef KINEMATICSLOAD_H_
#define KINEMATICSLOAD_H_

#include "Modelisations/Model.h"
#include "Loads/UnitaryLoad.h"

/**
* class KinematicsLoadInstance
*   Classe definissant une charge cinematique (issue d'AFFE_CHAR_CINE)
* @author Nicolas Sellenet
*/
class KinematicsLoadInstance: public DataStructure
{
    private:
        typedef boost::shared_ptr< VirtualMeshEntity > MeshEntityPtr;

        typedef list< DoubleLoadDisplacement > ListDoubleDisp;
        typedef ListDoubleDisp::iterator ListDoubleDispIter;

        typedef list< DoubleLoadTemperature > ListDoubleTemp;
        typedef ListDoubleTemp::iterator ListDoubleTempIter;

        // Modele support
        Model          _supportModel;
        // Listes des valeurs imposees DEPL_R et TEMP_R
        ListDoubleDisp _listOfDoubleImposedDisplacement;
        ListDoubleDisp _listOfDoubleImposedTemperature;

    public:
        /**
        * Constructeur
        */
        KinematicsLoadInstance();

        /**
        * Ajout d'une valeur acoustique imposee sur un groupe de mailles
        * @param nameOfGroup Nom du groupe sur lequel imposer la valeur
        * @param value Valeur imposee
        * @return Booleen indiquant que tout s'est bien passe
        */
        bool addImposedAcousticDOFOnElements( string nameOfGroup, double value )
        {
            throw "Not yet implemented";
        };

        /**
        * Ajout d'une valeur acoustique imposee sur un groupe de noeuds
        * @param nameOfGroup Nom du groupe sur lequel imposer la valeur
        * @param value Valeur imposee
        * @return Booleen indiquant que tout s'est bien passe
        */
        bool addImposedAcousticDOFOnNodes( string nameOfGroup, double value )
        {
            throw "Not yet implemented";
        };

        /**
        * Ajout d'une valeur mecanique imposee sur un groupe de mailles
        * @param nameOfGroup Nom du groupe sur lequel imposer la valeur
        * @param value Valeur imposee
        * @return Booleen indiquant que tout s'est bien passe
        */
        bool addImposedMechanicalDOFOnElements( AsterCoordinates coordinate,
                                                double value, string nameOfGroup )
        {
            // On verifie que le pointeur vers le modele support ET que le modele lui-meme
            // ne sont pas vides
            if ( _supportModel.isEmpty() || _supportModel->isEmpty() )
                throw "The support model is empty";
            if ( ! _supportModel->getSupportMesh()->hasGroupOfElements( nameOfGroup ) )
                throw nameOfGroup + "not in support mesh";

            MeshEntityPtr meshEnt( new GroupOfElementsInstance( nameOfGroup ) );
            DoubleLoadDisplacement resu( meshEnt, coordinate, value );
            _listOfDoubleImposedDisplacement.push_back( resu );
            return true;
        };

        /**
        * Ajout d'une valeur mecanique imposee sur un groupe de noeuds
        * @param nameOfGroup Nom du groupe sur lequel imposer la valeur
        * @param value Valeur imposee
        * @return Booleen indiquant que tout s'est bien passe
        */
        bool addImposedMechanicalDOFOnNodes( AsterCoordinates coordinate,
                                             double value, string nameOfGroup )
        {
            // On verifie que le pointeur vers le modele support ET que le modele lui-meme
            // ne sont pas vides
            if ( _supportModel.isEmpty() || _supportModel->isEmpty() )
                throw "The support model is empty";
            if ( ! _supportModel->getSupportMesh()->hasGroupOfElements( nameOfGroup ) )
                throw nameOfGroup + "not in support mesh";

            MeshEntityPtr meshEnt( new GroupOfNodesInstance( nameOfGroup ) );
            DoubleLoadDisplacement resu( meshEnt, coordinate, value );
            _listOfDoubleImposedDisplacement.push_back( resu );
            return true;
        };

        /**
        * Ajout d'une valeur thermique imposee sur un groupe de mailles
        * @param nameOfGroup Nom du groupe sur lequel imposer la valeur
        * @param value Valeur imposee
        * @return Booleen indiquant que tout s'est bien passe
        */
        bool addImposedThermalDOFOnElements( AsterCoordinates coordinate,
                                             double value, string nameOfGroup )
        {
            // On verifie que le pointeur vers le modele support ET que le modele lui-meme
            // ne sont pas vides
            if ( _supportModel.isEmpty() || _supportModel->isEmpty() )
                throw "The support model is empty";
            if ( ! _supportModel->getSupportMesh()->hasGroupOfElements( nameOfGroup ) )
                throw nameOfGroup + "not in support mesh";

            MeshEntityPtr meshEnt( new GroupOfElementsInstance( nameOfGroup ) );
            DoubleLoadDisplacement resu( meshEnt, coordinate, value );
            _listOfDoubleImposedTemperature.push_back( resu );
            return true;
        };

        /**
        * Ajout d'une valeur thermique imposee sur un groupe de noeuds
        * @param nameOfGroup Nom du groupe sur lequel imposer la valeur
        * @param value Valeur imposee
        * @return Booleen indiquant que tout s'est bien passe
        */
        bool addImposedThermalDOFOnNodes( AsterCoordinates coordinate,
                                          double value, string nameOfGroup )
        {
            // On verifie que le pointeur vers le modele support ET que le modele lui-meme
            // ne sont pas vides
            if ( _supportModel.isEmpty() || _supportModel->isEmpty() )
                throw "The support model is empty";
            if ( ! _supportModel->getSupportMesh()->hasGroupOfElements( nameOfGroup ) )
                throw nameOfGroup + "not in support mesh";

            MeshEntityPtr meshEnt( new GroupOfNodesInstance( nameOfGroup ) );
            DoubleLoadDisplacement resu( meshEnt, coordinate, value );
            _listOfDoubleImposedTemperature.push_back( resu );
            return true;
        };

        /**
        * Construction de la charge (appel a OP0101)
        * @return Booleen indiquant que tout s'est bien passe
        */
        bool build();

        /**
        * Definition du modele support
        * @param currentMesh objet Model sur lequel la charge reposera
        */
        void setSupportModel( Model& currentModel )
        {
            _supportModel = currentModel;
        };
};

/**
* class KinematicsLoad
*   Enveloppe d'un pointeur intelligent vers un KinematicsLoadInstance
* @author Nicolas Sellenet
*/
class KinematicsLoad
{
    public:
        typedef boost::shared_ptr< KinematicsLoadInstance > KinematicsLoadPtr;

    private:
        KinematicsLoadPtr _kinematicsLoadPtr;

    public:
        KinematicsLoad(bool initilisation = true): _kinematicsLoadPtr()
        {
            if ( initilisation == true )
                _kinematicsLoadPtr = KinematicsLoadPtr( new KinematicsLoadInstance() );
        };

        ~KinematicsLoad()
        {};

        KinematicsLoad& operator=(const KinematicsLoad& tmp)
        {
            _kinematicsLoadPtr = tmp._kinematicsLoadPtr;
            return *this;
        };

        const KinematicsLoadPtr& operator->() const
        {
            return _kinematicsLoadPtr;
        };

        bool isEmpty() const
        {
            if ( _kinematicsLoadPtr.use_count() == 0 ) return true;
            return false;
        };
};

#endif /* KINEMATICSLOAD_H_ */
