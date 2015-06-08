subroutine meamat(modele, mate, carele, lischa, partps,&
                  numedd, assmat, solveu, matass, maprec,&
                  base, compor)
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
#include "asterfort/asmatr.h"
#include "asterfort/detrsd.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/merime.h"
#include "asterfort/preres.h"
#include "asterfort/uttcpu.h"
#include "asterfort/vrcref.h"
    aster_logical :: assmat
    character(len=1) :: base
    character(len=19) :: lischa, solveu, matass, maprec
    character(len=24) :: modele, carele, numedd, compor
    character(len=*) :: mate
    real(kind=8) :: partps(3)
!
! ----------------------------------------------------------------------
!     MECANIQUE STATIQUE - ACTUALISATION DE LA MATRICE ASSEMBLEE
!     **                   *                   ***
! ----------------------------------------------------------------------
! IN  MODELE  : NOM DU MODELE
! IN  MATE    : NOM DU MATERIAU
! IN  CARELE  : NOM D'1 CARAC_ELEM
! IN  LISCHA  : INFORMATION SUR LES CHARGEMENTS
! IN  PARTPS  : PARAMETRES TEMPORELS
! IN  NUMEDD  : PROFIL DE LA MATRICE
! IN  ASSMAT  : BOOLEEN POUR LE CALCUL DE LA MATRICE
! IN  SOLVEU  : METHODE DE RESOLUTION 'LDLT' OU 'GCPC'
! OUT MATASS,MAPREC  MATRICE DE RIGIDITE ASSEMBLEE
! IN  BASE    : BASE DE TRAVAIL
! IN/OUT  MAPREC  : MATRICE PRECONDITIONNEE
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
    integer :: jchar, jinf, nh, ierr, ibid, nchar
    real(kind=8) :: time
    character(len=8) :: matele
    character(len=24) :: charge, infoch
    aster_logical :: ass1er
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
!             12345678
    matele = '&&MATELE'
!
! 1.2. ==> LES CONSTANTES
!
    time = partps(1)
!
    charge = lischa//'.LCHA'
!
    call jeveuo(charge, 'L', jchar)
    infoch = lischa//'.INFC'
    call jeveuo(infoch, 'L', jinf)
    nchar = zi(jinf)
!
    nh = 0
!
    ass1er = .false.
!
!
!
!====
! 2. LE PREMIER MEMBRE
!====
!
! 2.1. ==> CALCULS ELEMENTAIRES DU 1ER MEMBRE:
!
    if (assmat) then
!
        call uttcpu('CPU.OP0046.1', 'DEBUT', ' ')
        call merime(modele(1:8), nchar, zk24(jchar), mate, carele(1:8),&
                    .true._1, time, compor, matele, nh,&
                    base)
        ass1er = .true.
        call uttcpu('CPU.OP0046.1', 'FIN', ' ')
!
    endif
!
! 2.2. ==> ASSEMBLAGE
!
    if (ass1er) then
!
        call uttcpu('CPU.OP0046.2', 'DEBUT', ' ')
        call asmatr(1, matele, ' ', numedd, solveu,&
                    lischa, 'ZERO', 'V', 1, matass)
        call detrsd('MATR_ELEM', matele)
!
! 2.3. ==> DECOMPOSITION OU CALCUL DE LA MATRICE DE PRECONDITIONEMENT
!
        call preres(solveu, 'V', ierr, maprec, matass,&
                    ibid, -9999)
!
!
        ass1er = .false.
        call uttcpu('CPU.OP0046.2', 'FIN', ' ')
!
    endif
!
    call jedema()
end subroutine
