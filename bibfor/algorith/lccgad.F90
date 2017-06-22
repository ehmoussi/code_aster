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

subroutine lccgad(fami, kpg, ksp, mat, option,&
                  mu, su, glis, dde, vim,&
                  vip, wkin)
!
!
    implicit none
#include "asterf_types.h"
#include "asterfort/rcvalb.h"
!
    integer :: mat, kpg, ksp
    real(kind=8) :: mu, su, glis, dde(2)
    real(kind=8) :: vim(*), vip(*), wkin(2)
    character(len=16) :: option
    character(len=*) :: fami
!
!-----------------------------------------------------------------------
!            LOI DE COMPORTEMENT COHESIVE CABLE_GAINE_FROT
!            POUR LES ELEMENTS DE CABLE/GAINE
!
! IN : FAMI    : FAMILLE DE POINT DE GAUSS UTILISE
!      KPG     : NUMERO Du POINT DE GAUSS
!      KSP     : NUMERO DU SOUS POINT
!      MAT     : MATERIAU
!      OPTION  : OPTION CALCULEE
!      MU      : LAGRANGE
!      SU      : SAUT DE U
!      VIM     : VARIABLES INTERNES
!                |1   : GLISSEMENT
!                |2   : INDICATEUR GLISSEMENT
!      WKIN    : TENSION CABLE
!                COURBURE
!
! OUT : GLIS   : DELTA, SOLUTION DE LA MINIMISATION
!       DDEDT : D(DELTA)/DT
!       VIP   : VARIABLES INTERNES MISES A JOUR
!-----------------------------------------------------------------------
!
    aster_logical :: resi, rigi, elas, adh
    integer :: cod(3)
    real(kind=8) :: val(3), n, courb, de, sut
    real(kind=8) :: frot, r, mult, frotc
    character(len=16) :: nom(3)
    character(len=1) :: poum
!
    data nom /'FROT_LINE','PENA_LAGR','FROT_COURB'/
!-----------------------------------------------------------------------
!
! ---------------------------
! -- PRINCIPALES NOTATIONS --
! ---------------------------
!
! -  DONNEES D'ENTREE
!    MU     : LAGRANGE
!    SU     : SAUT DE U
!    VIM    : VARIABLES INTERNES
!             |1   : GLISSEMENT
!             |2   : INDICATEUR GLISSEMENT
!
! -  DONNEES DE SORTIE
!    DE     : DELTA
!    DDEDT  : DERIVEE DE DELTA
!    VIP    : VARIABLES INTERNES MISES A JOUR
!
!
! --------------------
! -- INITIALISATION --
! --------------------
!
!    OPTION CALCUL DU RESIDU OU CALCUL DE LA MATRICE TANGENTE
    resi = option(1:4).eq.'FULL' .or. option(1:4).eq.'RAPH'
    rigi = option(1:4).eq.'FULL' .or. option(1:4).eq.'RIGI'
    elas = option(11:14).eq.'ELAS'
!
!    RECUPERATION DES PARAMETRES PHYSIQUES
    if (option .eq. 'RIGI_MECA_TANG') then
        poum = '-'
    else
        poum = '+'
    endif
!
    n=wkin(1)
    courb=wkin(2)
!
    call rcvalb(fami, kpg, ksp, poum, mat,&
                ' ', 'CABLE_GAINE_FROT', 0, ' ', [0.d0],&
                3, nom, val, cod, 2)
!
!    PARAMETRE DU COMPORTEMENT DE LA LOI DE TALON-CURNIER
    frot = val(1)
    r = val(2)
    frotc = val(3)
!
    adh=(frot.eq.-1.d0)
!
    frot=frot+frotc*courb
!    DETERMINATION DU REGIME DE COMPORTEMENT
    if (resi) then
        sut=su-vim(1)
        vip(2)=0.d0
        vip(1)=vim(1)
        if (adh) then
            glis=0.d0
        else
            if (n .lt. 0.d0) n = 0.d0
            if (abs(mu+r*sut) .le. (frot*n)) then
                glis = vip(1)
            else
                if ((mu+r*sut) .gt. 0.d0) then
                    de=sut+(mu-frot*n)/r
                    vip(1)=vim(1)+de
                    vip(2)=-1.d0
                    glis=vip(1)
                else
                    de=sut+(mu+frot*n)/r
                    vip(1)=vim(1)+de
                    vip(2)=1.d0
                    glis=vip(1)
                endif
            endif
        endif
        adh=(vip(2).eq.0.d0)
        mult=vip(2)
    else
        adh=(vim(2).eq.0.d0)
        mult=vim(2)
    endif
! ----------------------
! -- MATRICE TANGENTE --
! ----------------------
!
    if (rigi) then
        if (adh) then
            dde(1)=0.d0
            dde(2)=0.d0
        else
            dde(1)=1.d0/r
            dde(2)=mult*frot/r
        endif
    endif
!
end subroutine
