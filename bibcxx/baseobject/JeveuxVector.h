#ifndef JEVEUXVECTOR_H_
#define JEVEUXVECTOR_H_

/* person_in_charge: nicolas.sellenet at edf.fr */

#include "definition.h"
#include "baseobject/JeveuxAllowedTypes.h"

#include <string>

using namespace std;

/**
* class template JeveuxVectorInstance
*   Cette classe permet de definir un vecteur Jeveux
* @author Nicolas Sellenet
*/
template< typename ValueType >
class JeveuxVectorInstance: private AllowedJeveuxType< ValueType >
{
    private:
        // Nom du vecteur Jeveux
        string     _name;
        // Pointeur vers la premiere position du vecteur Jeveux
        ValueType* _valuePtr;

    public:
        /**
        * Constructeur
        * @param name Nom jeveux du vecteur
        *   Attention, le pointeur est mis a zero. Avant d'utiliser ce vecteur,
        *   il faut donc faire appel a JeveuxVectorInstance::updateValuePointer
        */
        JeveuxVectorInstance(string nom): _name(nom), _valuePtr(NULL)
        {};

        /**
        * Destructeur
        */
        ~JeveuxVectorInstance()
        {
            if ( _name != "" )
            {
                CALL_JEDETR( const_cast< char* >( _name.c_str() ) );
            }
        };

        /**
        * Surcharge de l'operateur [] avec des const
        * @param i Indice dans le tableau Jeveux
        * @return la valeur du tableau Jeveux a la position i
        */
        const ValueType &operator[](int i) const
        {
            return _valuePtr[i];
        };

        /**
        * Surcharge de l'operateur [] sans const (pour les lvalue)
        * @param i Indice dans le tableau Jeveux
        * @return la valeur du tableau Jeveux a la position i
        */
        ValueType &operator[](int i)
        {
            return _valuePtr[i];
        };

        /**
        * Mise a jour du pointeur Jeveux
        * @return true si la mise a jour s'est bien passee
        */
        bool updateValuePointer()
        {
            _valuePtr = NULL;
            // Si on n'a pas de nom, on sort
            if ( _name == "" ) return false;

            long boolRetour;
            // Appel a jeexin pour verifier que le vecteur existe
            CALL_JEEXIN(_name.c_str(), &boolRetour);
            if ( boolRetour == 0 ) return false;

            const char* tmp = "L";
            CALL_JEVEUOC(_name.c_str(), tmp, (void*)(&_valuePtr));
            if ( _valuePtr == NULL ) return false;
            return true;
        };

        /**
        * Fonction d'allocation d'un vecteur Jeveux
        * @param jeveuxBase Base sur laquelle doit etre allouee le vecteur : 'G' ou 'V'
        * @param length Longueur du vecteur Jeveux a allouer
        * @return true si l'allocation s'est bien passee
        */
        bool allocate(string jeveuxBase, unsigned long length)
        {
            if ( _name != "" && length > 0 )
            {
                assert( jeveuxBase == "V" || jeveuxBase == "G" );
                long taille = length;
                const int intType = AllowedJeveuxType< ValueType >::numTypeJeveux;
                string carac = jeveuxBase + " V " + JeveuxTypesNames[intType];
                CALL_WKVECTC(_name.c_str(), carac.c_str(), &taille, (void*)(&_valuePtr));
                if ( _valuePtr == NULL ) return false;
            }
            else return false;
            return true;
        };
};

/**
* class template JeveuxVector
*   Enveloppe d'un pointeur intelligent vers un JeveuxVectorInstance
* @author Nicolas Sellenet
*/
template<class ValueType>
class JeveuxVector
{
    public:
        typedef boost::shared_ptr< JeveuxVectorInstance< ValueType > > JeveuxVectorTypePtr;

    private:
        JeveuxVectorTypePtr _jeveuxVectorPtr;

    public:
        JeveuxVector(string nom): _jeveuxVectorPtr( new JeveuxVectorInstance< ValueType > (nom) )
        {};

        ~JeveuxVector()
        {};

        JeveuxVector& operator=(const JeveuxVector< ValueType >& tmp)
        {
            _jeveuxVectorPtr = tmp._jeveuxVectorPtr;
            return *this;
        };

        const JeveuxVectorTypePtr& operator->(void) const
        {
            return _jeveuxVectorPtr;
        };

        JeveuxVectorInstance< ValueType >& operator*(void) const
        {
            return *_jeveuxVectorPtr;
        };

        bool isEmpty() const
        {
            if ( _jeveuxVectorPtr.use_count() == 0 ) return true;
            return false;
        };
};

typedef JeveuxVector< long > JeveuxVectorLong;
typedef JeveuxVector< short int > JeveuxVectorShort;
typedef JeveuxVector< double > JeveuxVectorDouble;
typedef JeveuxVector< double complex > JeveuxVectorComplex;
typedef JeveuxVector< char[8] > JeveuxVectorChar8;
typedef JeveuxVector< char[16] > JeveuxVectorChar16;
typedef JeveuxVector< char[24] > JeveuxVectorChar24;
typedef JeveuxVector< char[32] > JeveuxVectorChar32;
typedef JeveuxVector< char[80] > JeveuxVectorChar80;

#endif /* JEVEUXVECTOR_H_ */
