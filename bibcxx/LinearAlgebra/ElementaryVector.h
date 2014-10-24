#ifndef ELEMENTARYVECTOR_H_
#define ELEMENTARYVECTOR_H_

/* person_in_charge: nicolas.sellenet at edf.fr */

#include "DataStructure/DataStructure.h"
#include "MemoryManager/JeveuxVector.h"
#include "Materials/AllocatedMaterial.h"
#include "Loads/MechanicalLoad.h"

/**
* class ElementaryVectorInstance
*   Class definissant une sd_vect_elem
* @author Nicolas Sellenet
*/
class ElementaryVectorInstance: public DataStructure
{
    private:
        typedef list< MechanicalLoad > ListMechanicalLoad;
        typedef ListMechanicalLoad::iterator ListMechanicalLoadIter;

        // Objet Jeveux '.RERR'
        JeveuxVectorChar24     _description;
        // Objet Jeveux '.RELR'
        JeveuxVectorChar24     _listOfElementaryResults;
        // Booleen indiquant si la sd est vide
        bool                   _isEmpty;
        // Champ de materiau a utiliser
        AllocatedMaterial      _material;
        // Charges ajoutees aux vecteurs elementaires
        list< MechanicalLoad > _listOfMechanicalLoad;

    public:
        /**
        * Constructeur
        */
        ElementaryVectorInstance();

        /**
        * Destructeur
        */
        ~ElementaryVectorInstance()
        {};

        void addMechanicalLoad( MechanicalLoad& currentLoad )
        {
            _listOfMechanicalLoad.push_back( currentLoad );
        };

        /**
        * Calcul des matrices elementaires pour l'option CHAR_MECA
        */
        bool computeMechanicalLoads();

        /**
        * Methode permettant de savoir si les matrices elementaires sont vides
        * @return true si les matrices elementaires sont vides
        */
        bool isEmpty()
        {
            return _isEmpty;
        };

        /**
        * Methode permettant de definir le champ de materiau
        * @param currentMaterial objet AllocatedMaterial
        */
        void setAllocatedMaterial( const AllocatedMaterial& currentMaterial )
        {
            _material = currentMaterial;
        };
};

/**
* class ElementaryVector
*   Enveloppe d'un pointeur intelligent vers un ElementaryVector
* @author Nicolas Sellenet
*/
class ElementaryVector
{
    public:
        typedef boost::shared_ptr< ElementaryVectorInstance > ElementaryVectorPtr;

    private:
        ElementaryVectorPtr _elementaryVectorPtr;

    public:
        ElementaryVector(bool initialisation = true): _elementaryVectorPtr()
        {
            if ( initialisation == true )
                _elementaryVectorPtr = ElementaryVectorPtr( new ElementaryVectorInstance() );
        };

        ~ElementaryVector()
        {};

        ElementaryVector& operator=(const ElementaryVector& tmp)
        {
            _elementaryVectorPtr = tmp._elementaryVectorPtr;
            return *this;
        };

        const ElementaryVectorPtr& operator->() const
        {
            return _elementaryVectorPtr;
        };

        ElementaryVectorInstance& operator*(void) const
        {
            return *_elementaryVectorPtr;
        };

        bool isEmpty() const
        {
            if ( _elementaryVectorPtr.use_count() == 0 ) return true;
            return false;
        };
};

#endif /* ELEMENTARYVECTOR_H_ */
