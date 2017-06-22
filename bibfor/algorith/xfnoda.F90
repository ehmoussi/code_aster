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

subroutine xfnoda(imate, mecani, press1, enrmec, dimenr,&
                  dimcon, ndim, dt, fnoevo, congem,&
                  r, enrhyd, nfh)
! person_in_charge: daniele.colombo at ifpen.fr
! ======================================================================
    implicit none
#include "asterf_types.h"
#include "asterfort/rcvalb.h"
    aster_logical :: fnoevo
    integer :: mecani(5), press1(7), enrmec(3), dimenr, dimcon
    integer :: ndim, imate, yaenrm, adenme
    integer :: enrhyd(3), yaenrh, adenhy, nfh
    real(kind=8) :: dt, congem(dimcon), r(dimenr)
! ======================================================================
    integer :: nhom, yamec, yap1, addeme, adcome
    integer :: addep1, adcp11, i, ifh
    parameter    (nhom=3)
    real(kind=8) :: hom(nhom), pesa(3), rac2
    integer :: icodre(nhom)
    character(len=8) :: ncra5(nhom)
    data ncra5 / 'PESA_X','PESA_Y','PESA_Z' /
! ======================================================================
! --- RECUPERATION DE LA PESANTEUR DANS DEFI_MATERIAU ------------------
! ======================================================================
    call rcvalb('FPG1', 1, 1, '+', imate,&
                ' ', 'THM_DIFFU', 0, ' ', [0.d0],&
                nhom, ncra5, hom, icodre, 1)
    pesa(1)=hom(1)
    pesa(2)=hom(2)
    pesa(3)=hom(3)
    rac2 = sqrt(2.0d0)
! ======================================================================
! --- DETERMINATION DES VARIABLES CARACTERISANT LE MILIEU --------------
! ======================================================================
    yamec = mecani(1)
    addeme = mecani(2)
    yap1 = press1(1)
    addep1 = press1(3)
    adcp11 = press1(4)
    adcome = mecani(3)
    yaenrm = enrmec(1)
    adenme = enrmec(2)
    yaenrh = enrhyd(1)
    adenhy = enrhyd(2)
! ======================================================================
! --- COMME CONGEM CONTIENT LES VRAIES CONTRAINTES ET ------------------
! --- COMME PAR LA SUITE ON TRAVAILLE AVEC SQRT(2)*SXY -----------------
! --- ON COMMENCE PAR MODIFIER LES CONGEM EN CONSEQUENCE ---------------
! ======================================================================
    if (yamec .eq. 1) then
        do 100 i = 4, 6
            congem(adcome+6+i-1) = congem(adcome+6+i-1)*rac2
            congem(adcome+i-1) = congem(adcome+i-1)*rac2
100     continue
    endif
! ======================================================================
! --- CALCUL DU RESIDU R (TERMES CLASSIQUES ) --------------------------
! ======================================================================
    if (yamec .eq. 1) then
        do 6 i = 1, 6
            r(addeme+ndim+i-1)= r(addeme+ndim+i-1)+congem(adcome-1+i)
  6     continue
        do 7 i = 1, 6
            r(addeme+ndim-1+i)=r(addeme+ndim-1+i)+congem(adcome+6+i-1)
  7     continue
!
        if (yap1 .eq. 1) then
            do 8 i = 1, ndim
                r(addeme+i-1)=r(addeme+i-1) - pesa(i)*congem(adcp11)
  8         continue
        endif
    endif
! ======================================================================
! --- CALCUL DU RESIDU R (TERMES HEAVISIDE ) ---------------------------
! ======================================================================
    if (yaenrm .eq. 1) then
        if (yamec .eq. 1) then
            if (yap1 .eq. 1) then
              do ifh = 1, nfh
                do 11 i = 1, ndim
                    r(adenme+i-1+(ifh-1)*(ndim+1))=r(adenme+i-1+(ifh-1)*&
                                          (ndim+1))-pesa(i)*congem(adcp11)
 11             continue
              end do
            endif
        endif
    endif
! ======================================================================
    if (fnoevo) then
! ======================================================================
! --- TERMES DEPENDANT DE DT DANS FORC_NODA POUR STAT_NON_LINE ---------
! ======================================================================
        if (yap1 .eq. 1) then
            do 112 i = 1, ndim
                r(addep1+i)=r(addep1+i)+dt*congem(adcp11+i)
112         continue
        endif
    endif
! ======================================================================
end subroutine
