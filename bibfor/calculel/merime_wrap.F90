subroutine merime_wrap(modelz, nchar, lchar, mate, carelz,&
                       exiti0, time, compoz, matelz, nh,&
                       basz)
!
! ----------------------------------------------------------------------
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
#include "asterfort/merime.h"
    integer :: nchar, nh
    real(kind=8) :: time
    character(len=*) :: modelz, carelz, matelz
    character(len=*) :: lchar(*), mate, basz, compoz
    integer :: exiti0
!
! ----------------------------------------------------------------------
!
! APPEL A MERIME
!
! ----------------------------------------------------------------------
!
! IN  MODELE : NOM DU MODELE
! IN  NCHAR  : NOMBRE DE CHARGES
! IN  LCHAR  : LISTE DES CHARGES
! IN  MATE   : CARTE DE MATERIAU
! IN  CARELE : CHAMP DE CARAC_ELEM
! IN  MATELZ : NOM DU MATR_ELEM RESULTAT
! IN  EXITI0 : VRAI SI L'INSTANT EST DONNE
! IN  TIME   : INSTANT DE CALCUL
! IN  NH     : NUMERO D'HARMONIQUE DE FOURIER
! IN  BASE   : NOM DE LA BASE
! IN  COMPOR : COMPOR POUR LES MULTIFIBRE (POU_D_EM)
!
! ----------------------------------------------------------------------
!
    aster_logical :: exitim
!
! ----------------------------------------------------------------------
!
    exitim = exiti0
    call merime(modelz, nchar, lchar, mate, carelz,&
                exitim, time, compoz, matelz, nh,&
                basz)
end subroutine
