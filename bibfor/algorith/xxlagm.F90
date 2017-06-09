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

subroutine xxlagm(ffc, idepl, idepm, lact, ndim,&
                  nnol, pla, reac, reac12, tau1,&
                  tau2, nvec)
    implicit none
#include "jeveux.h"
!
! IN CFACE  : CONNECTIVITE FACETTES DE CONTACT
! IN FFC    : FONCTIONS DE FORME DE CONTACT
! IN IDEPL  : ADRESSE DEPLACEMENT COURANT
! IN IDEPM  : ADRESSE DEPLACEMENT INSTANT -
! IN IFA    : NUMERO FACETTE DE CONTACT
! IN IPGF   : NUMERO POINT DE GAUSS DE CONTACT
! IN IVFF   : ADRESSE FONCTION DE FORME EL PARENT
! IN LACT   : DDL DE LAGRANGE ACTIF OU NON
! IN NDIM   : DIMENSION DU MODELE
! IN NNOF   : NOMBRE DE NOEUDS D UNE FACETTE DE CONTACT
! IN NNOL   : NOMBRE DE NOEUDS EL PARENT PORTEURS DE DDL LAGRANGE
! IN NOEUD  : FORMULATION AUX NOEUDS
! IN PLA    : PLACE DES DDLS DE LAGRANGE
! OUT REAC  : REACTION DE CONTACT AU POINT DE GAUSS
! OUT REAC12: REACTION DE FROTTEMENT AU POINT DE GAUSS
! IN TAU1   : 1ERE TANGENTE SURFACE DE CONTACT
! IN TAU2   : 2EME TANGENTE (3D)
#include "asterfort/vecini.h"
    integer :: i, idepl, idepm
    integer :: j, lact(8), ndim, nli, nnol
    integer :: pla(27), pli, nvec
    real(kind=8) :: ffc(8), ffi, reac, reac12(3), tau1(3), tau2(3)
!
! --- RÉACTION CONTACT = SOMME DES FF(I).LAMBDA(I) POUR I=1,NNOL
! --- RÉACTION FROTT = SOMME DES FF(I).(LAMB1(I).TAU1+LAMB2(I).TAU2)
! --- (DEPDEL+DEPMOI)
    reac=0.d0
    call vecini(3, 0.d0, reac12)
    do 120 i = 1, nnol
        pli=pla(i)
        ffi=ffc(i)
        nli=lact(i)
        if (nli .eq. 0) goto 120
        reac = reac + ffi * zr(idepl-1+pli)
        if (nvec .eq. 2) then
            reac = reac + ffi * zr(idepm-1+pli)
        endif
        do 121 j = 1, ndim
            if (ndim .eq. 3) then
                reac12(j)=reac12(j)+ffi*(zr(idepl-1+pli+1)*tau1(j)&
                +zr(idepl-1+pli+2)*tau2(j))
                if (nvec .eq. 2) then
                    reac12(j)=reac12(j)+ffi*(zr(idepm-1+pli+1)*tau1(j)&
                    +zr(idepm-1+pli+2)*tau2(j))
                endif
            else if (ndim.eq.2) then
                reac12(j)=reac12(j)+ffi*zr(idepl-1+pli+1)*tau1(j)
                if (nvec .eq. 2) then
                    reac12(j)=reac12(j)+ffi*zr(idepm-1+pli+1)*tau1(j)
                endif
            endif
121      continue
120  continue
end subroutine
