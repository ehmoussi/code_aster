! --------------------------------------------------------------------
! Copyright (C) 1991 - 2017 - EDF R&D - www.code-aster.org
! This file is part of code_aster.
!
! code_aster is free software: you can redistribute it and/or modify
! it under the terms of the GNU General Public License as published by
! the Free Software Foundation, either version 3 of the License, or
! (at your option) any later version.
!
! code_aster is distributed in the hope that it will be useful,
! but WITHOUT ANY WARRANTY; without even the implied warranty of
! MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
! GNU General Public License for more details.
!
! You should have received a copy of the GNU General Public License
! along with code_aster.  If not, see <http://www.gnu.org/licenses/>.
! --------------------------------------------------------------------

subroutine mnlru(imat, xcdl, parcho, adime, xvect,&
                 ninc, nd, nchoc, h, hf,&
                 xru)
    implicit none
!
!
!     MODE_NON_LINE CALCUL DE R(U)
!     -    -   -              - -
! ----------------------------------------------------------------------
!
! CALCUL R(U) = L(U) + Q(U,U)
! ----------------------------------------------------------------------
! IN  IMAT   : I(2) : DESCRIPTEUR DES MATRICES :
!                       - IMAT(1) => MATRICE DE RAIDEUR
!                       - IMAT(2) => MATRICE DE MASSE
! IN  XCDL   : K14  : INDICE DES CONDITIONS AUX LIMITES
! IN  PARCHO : K14  : NOM DE LA SD PARAMETRE DES CONTACTEURS
! IN  ADIME  : K14  : SD PARAMETRE POUR ADIMENSIONNEMENT
! IN  XVECT  : K14  : NOM DU VECTEUR SOLUTION
! IN  NINC   : I    : NOMBRE D INCONNUES DU SYSTEME
! IN  ND     : I    : NOMBRE DE DEGRES DE LIBERTE
! IN  NCHOC  : I    : NOMBRE DE CONTACTEURS
! IN  H      : I    : NOMBRE D'HARMONIQUES POUR LE DEPLACEMENT
! IN  HF     : I    : NOMBRE D'HARMONIQUES POUR LA FORCE
! OUT XRU    : K14  : NOM DU VECTEUR DE SORTIE, R(XVECT)=XRU
! ----------------------------------------------------------------------
!
!
#include "jeveux.h"
! ----------------------------------------------------------------------
! --- DECLARATION DES ARGUMENTS DE LA ROUTINE
! ----------------------------------------------------------------------
#include "blas/daxpy.h"
#include "blas/dcopy.h"
#include "blas/dscal.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/mnlcst.h"
#include "asterfort/mnline.h"
#include "asterfort/mnlqnl.h"
#include "asterfort/wkvect.h"
    integer :: imat(2), ninc, nd, nchoc, h, hf
    character(len=14) :: xcdl, parcho, adime, xvect, xru
! ----------------------------------------------------------------------
! --- DECLARATION DES VARIABLES LOCALES
! ----------------------------------------------------------------------
    integer :: iru, ivint
    character(len=14) :: xvint
!
    call jemarq()
!    call jxveri(' ', ' ')
! ----------------------------------------------------------------------
! --- RECUPERATION DU POINTEUR DE R(XVECT)
! ----------------------------------------------------------------------
    call jeveuo(xru, 'E', iru)
    call dscal(ninc-1, 0.d0, zr(iru), 1)
! ----------------------------------------------------------------------
! --- CREATION D'UN VECTEUR INTERMEDIAIRE
! ----------------------------------------------------------------------
    xvint = '&&MNLRU.INT'
    call wkvect(xvint, 'V V R', ninc-1, ivint)
! ----------------------------------------------------------------------
! --- CALCUL DE R(XVECT)
! ----------------------------------------------------------------------
! --- CALCUL DE L0
    call dscal(ninc-1, 0.d0, zr(ivint), 1)
    call mnlcst(parcho, adime, ninc, nd, nchoc,&
                h, hf, xvint)
    call dcopy(ninc-1, zr(ivint), 1, zr(iru), 1)
! --- CALCUL DE L(XVECT)
    call dscal(ninc-1, 0.d0, zr(ivint), 1)
    call mnline(imat, xcdl, parcho, adime, xvect,&
                ninc, nd, nchoc, h, hf,&
                xvint)
    call daxpy(ninc-1, 1.d0, zr(ivint), 1, zr(iru),&
               1)
! --- CALCUL DE Q(XVECT,XVECT)
    call dscal(ninc-1, 0.d0, zr(ivint), 1)
    call mnlqnl(imat, xcdl, parcho, adime, xvect,&
                xvect, ninc, nd, nchoc, h,&
                hf, xvint)
! --- R(XVECT) = L0 + L(XVECT) + Q(XVECT,XVECT)
    call daxpy(ninc-1, 1.d0, zr(ivint), 1, zr(iru),&
               1)
! ----------------------------------------------------------------------
! --- DESTRUCTION DU VECTEUR INTERMEDIAIRE
! ----------------------------------------------------------------------
    call jedetr(xvint)
!
    call jedema()
!
end subroutine
