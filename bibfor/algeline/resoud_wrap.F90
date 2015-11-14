subroutine resoud_wrap(matass, matpre, solveu, chcine, nsecm,&
                       chsecm, chsolu, base, criter, prepo2,&
                       istop, iret)
    implicit none
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/resoud.h"
!-----------------------------------------------------------------------
!
    character(len=*) :: matass, matpre, solveu, chcine
    integer :: nsecm
    character(len=*) :: chsecm, chsolu, base
    character(len=*) :: criter
    integer :: prepo2
    integer :: istop, iret
!-----------------------------------------------------------------------
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
!-----------------------------------------------------------------------
! BUT : RESOUDRE UN SYSTEME LINEAIRE D'EQUATIONS (REEL OU COMPLEXE)
!-----------------------------------------------------------------------
!
! ARGUMENTS :
!------------
!
! IN/JXIN  K19 MATASS : MATR_ASSE PREMIER MEMBRE DU SYSTEME LINEAIRE
! IN/JXIN  K19 MATPRE : MATR_ASSE DE PRECONDITIONNEMENT
!                       POUR SOLVEUR ITERATIF GCPC (OU ' ' SINON)
! IN/JXIN  K19 SOLVEU : SD_SOLVEUR (OU ' ')
!                       SI SOLVEU=' ' ON PREND LE SOLVEUR DE MATASS
! IN/JXIN  K*  CHCINE : CHAMP ASSOCIE AUX CHARGES CINEMATIQUES (OU ' ')
! IN       I   NSECM  : / 0 => ON UTILISE CHSECM, CHSOLU, BASE
!                       / N => ON UTILISE RSOLU (OU CSOLU)
!                         N : NOMBRE DE SECONDS MEMBRES
! IN/JXIN  K*  CHSECM : CHAMP SECOND MEMBRE DU SYSTEME LINEAIRE
! IN/JXOUT K*  CHSOLU : CHAMP SOLUTION DU SYSTEME LINEAIRE
! IN       K*  BASE   : BASE SUR LAQUELLE ON CREE CHSOLU
! IN/JXOUT K*  CRITER : SD_CRITER (CRITERES DE CONVERGENCE)
!                       POUR SOLVEUR ITERATIF GCPC (OU ' ' SINON)
! IN       L   PREPO2 : / 1  => ON FAIT LES PRE ET POST-TRAITEMENTS
!                                    DU SMB ET DE LA SOLUTION
!                       / 0  => ON NE FAIT AUCUN TRAITEMENT
!                                    (EN MODAL PAR EXEMPLE)
! IN       I   ISTOP  : COMPORTEMENT EN CAS D'ERREUR (CE PARAMETRE N'A
!                       D'UTILITE QUE POUR UN SOLVEUR ITERATIF)
!                       / 0     : ON S'ARRETE EN <F>
!                       / 2     : ON CONTINUE SANS MESSAGE D'ERREUR
!                       / -9999 : ON PREND LA VALEUR DEFINIE DANS LA
!                                 SD_SOLVEUR POUR STOP_SINGULIER
! OUT      I   IRET   : CODE RETOUR
!                       / 0 : OK (PAR DEFAUT POUR SOLVEURS DIRECTS)
!                       / 1 : ECHEC (NOMBRE MAX. D'ITERATIONS ATTEINT)
! ----------------------------------------------------------------------
    character(len=24) :: kxfem
    character(len=19) :: matas1, solve1
    real(kind=8) :: rsolu(1)
    complex(kind=8) :: csolu(1)
    aster_logical prepos
! ----------------------------------------------------------------------
!
    prepos = int_to_logical(prepo2)
    call resoud(matass, matpre, solveu, chcine, nsecm,&
                chsecm, chsolu, base, rsolu, csolu,&
                criter, prepos, istop, iret)
!
end subroutine
