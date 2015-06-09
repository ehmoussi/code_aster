subroutine meachm(modele, mate, carele, fomult, lischa,&
                  partps, numedd, vecass, compor)
!
! ======================================================================
! COPYRIGHT (C) 1991 - 2015  EDF R&D                  WWW.CODE-ASTER.ORG
! THIS PROGRAM IS FREE SOFTWARE; YOU CAN REDISTRIBUTE IT AND/OR MODIFY
! IT UNDER THE TERMS OF THE GNU GENERAL PUBLIC LICENSE AS PUBLISHED BY
! THE FREE SOFTWARE FOUNDATION; EITHER VERSION 2 OF THE LICENSE, OR
! (AT YOUR OPTION) ANY LATER VERSION.
!
! THIS PROGRAM IS DISTRIBUTED IN THE HOPE THAT IT WILL BE USEFUL, BUT
! WITHOUT ANY WARRANTY; WITHOUT EVEN THE IMPLIED WARRANTY OF
! MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE. SEE THE GNU
! GENERAL PUBLIC LICENSE FOR MORE DETAILS.
!
! YOU SHOULD HAVE RECEIVED A COPY OF THE GNU GENERAL PUBLIC LICENSE
! ALONG WITH THIS PROGRAM; IF NOT, WRITE TO EDF R&D CODE_ASTER,
!    1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
! ======================================================================
!
    implicit none
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/asasve.h"
#include "asterfort/ascavc.h"
#include "asterfort/ascova.h"
#include "asterfort/detrsd.h"
#include "asterfort/fetccn.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/nmvcd2.h"
#include "asterfort/nmvcex.h"
#include "asterfort/nmvcle.h"
#include "asterfort/vechme.h"
#include "asterfort/vectme.h"
#include "asterfort/vecvme.h"
#include "asterfort/vedime.h"
#include "asterfort/velame.h"
#include "asterfort/vrcref.h"
    character(len=19) :: lischa, vecass
    character(len=24) :: modele, carele, fomult, numedd, compor
    character(len=*) :: mate
    real(kind=8) :: partps(3)
!
! ----------------------------------------------------------------------
!     MECANIQUE STATIQUE - ACTUALISATION DU CHARGEMENT CINEMATIQUE
!     **                   *                **         *
! ----------------------------------------------------------------------
! IN  MODELE  : NOM DU MODELE
! IN  MATE    : NOM DU MATERIAU
! IN  CARELE  : NOM D'1 CARAC_ELEM
! IN  FOMULT  : LISTE DES FONCTIONS MULTIPLICATRICES
! IN  LISCHA  : INFORMATION SUR LES CHARGEMENTS
! IN  PARTPS  : PARAMETRES TEMPORELS
! IN  NUMEDD  : PROFIL DE LA MATRICE
! OUT VECASS  : VECTEUR ASSEMBLE SECOND MEMBRE
! IN  COMPOR  : COMPOR POUR LES MULTIFIBRE (POU_D_EM)
!----------------------------------------------------------------------
!
!
!
! 0.2. ==> COMMUNS
!
!
! 0.3. ==> VARIABLES LOCALES
!
    character(len=6) :: nompro
    parameter ( nompro = 'MEACMV' )
!
    integer :: jtp, typcum
    real(kind=8) :: time
    character(len=1) :: typres
    character(len=14) :: com
    character(len=19) :: chvref, chvarc
    character(len=16) :: option
    character(len=19) :: chamn1, chamn2, chamn3, chamn4
    character(len=24) :: k24bid, blan24, vediri, vadiri, velapl, valapl, vecham
    character(len=24) :: vacham, chlapl, chdiri, chcham, chths, charge, infoch
    character(len=24) :: vecths
    aster_logical :: lhydr, lsech, ltemp, lptot
!
! DEB-------------------------------------------------------------------
!====
! 1. PREALABLES
!====
!
    call jemarq()
!
! 1.2. ==> NOM DES STRUCTURES
!
! 1.2.1. ==> FIXES
!
!               12   345678   9012345678901234
    com = '&&'//nompro//'.COM__'
    chvarc = '&&'//nompro//'.CHVRC'
!     -- POUR NE CREER Q'UN SEUL CHAMP DE VARIABLES DE REFERENCE
    chvref = modele(1:8)//'.CHVCREF'
!
!
    blan24 = ' '
    k24bid = blan24
    lhydr=.false.
    lsech=.false.
    lptot=.false.
    chths = blan24
!
! 1.2. ==> LES CONSTANTES
!
    time = partps(1)
!
    charge = lischa//'.LCHA'
    infoch = lischa//'.INFC'
!
    call nmvcle(modele, mate, carele, time, com)
    call vrcref(modele(1:8), mate(1:8), carele(1:8), chvref)
    call nmvcex('TOUT', com, chvarc)
    call nmvcd2('HYDR', mate, lhydr)
    call nmvcd2('PTOT', mate, lptot)
    call nmvcd2('SECH', mate, lsech)
    call nmvcd2('TEMP', mate, ltemp)
!
    typres = 'R'
!
!
!
!====
! 2. LES CHARGEMENTS
!====
!
! 2.1. ==> LES DIRICHLETS
!
    vadiri = blan24
    vediri = blan24
    chdiri = blan24
    call vedime(modele, charge, infoch, time, typres,&
                vediri)
    call asasve(vediri, numedd, typres, vadiri)
    call ascova('D', vadiri, fomult, 'INST', time,&
                typres, chdiri)
!
! 2.2. ==> CAS DU CHARGEMENT TEMPERATURE, HYDRATATION, SECHAGE,
!          PRESSION TOTALE (CHAINAGE HM)
!
    if (ltemp .or. lhydr .or. lsech .or. lptot) then
        vecths = blan24
        if (ltemp) then
            call vectme(modele, carele, mate, compor, com,&
                        vecths)
            call asasve(vecths, numedd, typres, chths)
        endif
        if (lhydr) then
            option = 'CHAR_MECA_HYDR_R'
            call vecvme(option, modele, carele, mate, compor,&
                        com, numedd, chths)
        endif
        if (lptot) then
            option = 'CHAR_MECA_PTOT_R'
            call vecvme(option, modele, carele, mate, compor,&
                        com, numedd, chths)
        endif
        if (lsech) then
            option = 'CHAR_MECA_SECH_R'
            call vecvme(option, modele, carele, mate, compor,&
                        com, numedd, chths)
        endif
!
        call jeveuo(chths, 'L', jtp)
        chths=zk24(jtp)(1:19)
    endif
!
! 2.3. ==> FORCES DE LAPLACE
!
    valapl = blan24
    velapl = blan24
    chlapl = blan24
    k24bid = blan24
    call velame(modele, charge, infoch, k24bid, velapl)
    call asasve(velapl, numedd, typres, valapl)
    call ascova('D', valapl, fomult, 'INST', time,&
                typres, chlapl)
!
! 2.4. ==> AUTRES CHARGEMENTS
!
    vacham = blan24
    vecham = blan24
    chcham = blan24
    k24bid = blan24
!
    call vechme('S', modele, charge, infoch, partps,&
                carele, mate, vecham, varc_currz = chvarc)
    call asasve(vecham, numedd, typres, vacham)
    call ascova('D', vacham, fomult, 'INST', time,&
                typres, chcham)
!
! 2.6. ==> SECOND MEMBRE DEFINITIF : VECASS
!
    typcum = 3
    chamn1 = chdiri(1:19)
    chamn2 = chcham(1:19)
    chamn3 = chlapl(1:19)
    if (chths(1:19) .ne. ' ') then
        typcum = 4
        chamn4 = chths(1:19)
    endif
!
! 2.6.2. ==> CONCATENATION DES SECOND(S) MEMBRE(S)
!
    call fetccn(chamn1, chamn2, chamn3, chamn4, typcum,&
                vecass)
!
!====
! 3. DESTRUCTION DES CHAMPS TEMPORAIRES
!====
!
    call detrsd('VECT_ELEM', vediri(1:19))
    call detrsd('CHAMP_GD', chdiri(1:19))
    call detrsd('VECT_ELEM', velapl(1:19))
    call detrsd('CHAMP_GD', chlapl(1:19))
    call detrsd('VECT_ELEM', vecham(1:19))
    call detrsd('CHAMP_GD', chcham(1:19))
    if (ltemp) then
        call detrsd('VECT_ELEM', vecths(1:19))
        call detrsd('CHAMP_GD', chths(1:19))
    endif
!
    call jedema()
end subroutine
