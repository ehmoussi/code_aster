! --------------------------------------------------------------------
! Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
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

module visc_norton_module

! ----------------------------------------------------------------------
! VISCOSITE DE NORTON: 
!   Gestion du terme de viscosite et derivee
!   Gestion du changement de variable dka <-> vsc
! ----------------------------------------------------------------------

    implicit none
    private
    public:: VISCO, Init, f_dka, f_vsc, ddka_vsc, dkv_vsc, dkv_dka, solve_slope_dka


#include "asterc/r8gaem.h"
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/rcvalb.h"
#include "asterfort/utmess.h"


    type VISCO
        aster_logical:: visc   = ASTER_FALSE
        aster_logical:: active = ASTER_FALSE
        real(kind=8) :: v0 = 0.d0
        real(kind=8) :: q  = 2.d0
    end type VISCO
       
    
contains


! =====================================================================
!  OBJECT CREATION AND INITIALISATION
! =====================================================================

function Init(visc,fami,kpg,ksp,imate,deltat)  result(self)
        
    implicit none
    
    aster_logical,intent(in)            :: visc
    integer,intent(in)                  :: kpg, ksp, imate
    real(kind=8),intent(in)             :: deltat
    character(len=*),intent(in)         :: fami
    type(VISCO)                         :: self
! --------------------------------------------------------------------------------------------------
! fami      Gauss point set
! kpg       Gauss point number
! ksp       Layer number (for structure elements)
! imate     material pointer
! deltat    time increment (instap - instam)
! --------------------------------------------------------------------------------------------------
    integer,parameter:: nb=2
! --------------------------------------------------------------------------------------------------
    integer             :: iok(nb)
    real(kind=8)        :: vale(nb)
    character(len=16)   :: nom(nb)
! --------------------------------------------------------------------------------------------------
    data nom /'N','K'/
! --------------------------------------------------------------------------------------------------

    self%visc = visc
    
    if (visc) then
        call rcvalb(fami,kpg,ksp,'+',imate,' ','NORTON',0,' ',[0.d0],nb,nom,vale,iok,2)
        self%q  = 1.d0/vale(1)
        self%v0 = vale(2)/deltat**self%q
    end if
            
    if (self%v0 .ne. 0.d0) then
        ASSERT(self%q .gt. 0 .and. self%q.lt.1.d0)
    end if
    
end function Init




! =====================================================================
!  NORTON VISCOSITY MODEL
! =====================================================================

! ----------------------------------------------------------------------
!  Viscosity as a function of dka
! ----------------------------------------------------------------------
function dka_to_vsc(self,dka) result(vsc)
    implicit none
    type(VISCO),intent(in) :: self
    real(kind=8),intent(in):: dka
    real(kind=8)           :: vsc
    vsc = self%v0 * dka**self%q
end function dka_to_vsc



! ----------------------------------------------------------------------
!  dka as a function of viscosity
! ----------------------------------------------------------------------
function vsc_to_dka(self,vsc) result(dka)
    implicit none
    type(VISCO),intent(in) :: self
    real(kind=8),intent(in):: vsc
    real(kind=8)           :: dka
    dka = (vsc/self%v0)**(1/self%q)
end function vsc_to_dka



! ----------------------------------------------------------------------
!  Derivative of viscosity with respect to dka
! ----------------------------------------------------------------------
function ddka_vsc(self,dka) result(drv)
    implicit none
    type(VISCO),intent(in) :: self
    real(kind=8),intent(in):: dka
    real(kind=8)           :: drv
    if (dka.eq.0.d0 .and. self%q.lt.1) then
        if (self%v0 .eq. 0.d0) then
            drv = 0.d0
        else
            ! infini -> on renvoie une valeur tres grande
            ! (ok car a priori utilise uniquement pour l'operateur tangent)
            drv = r8gaem() 
        end if
    else
        drv = (self%v0*self%q) * dka**(self%q-1)
    end if
end function ddka_vsc



! ----------------------------------------------------------------------
!  Derivative of dka with respect to viscosity
! ----------------------------------------------------------------------
function dvsc_dka(self,vsc) result(drv)
    implicit none
    type(VISCO),intent(in) :: self
    real(kind=8),intent(in):: vsc
    real(kind=8)           :: drv
    drv = (vsc/self%v0)**(1/self%q-1) / (self%q * self%v0)
end function dvsc_dka




! =====================================================================
!  USER INTERFACE
! =====================================================================

! Variable kv may be equal to dka (active=False) or vsc (active=True)


! ----------------------------------------------------------------------
!  Compute dka from kv
! ----------------------------------------------------------------------
function f_dka(self,kv) result (dka)
    implicit none
    type(VISCO),intent(in)  :: self
    real(kind=8),intent(in) :: kv
    real(kind=8)            :: dka
! ----------------------------------------------------------------------
    if (self%active) then
        dka = vsc_to_dka(self,kv)
    else
        dka = kv
    end if
end function f_dka



! ----------------------------------------------------------------------
!  Compute the derivative of dka with respect to kv
! ----------------------------------------------------------------------
function dkv_dka(self,kv) result (drv)
    implicit none
    type(VISCO),intent(in)  :: self
    real(kind=8),intent(in) :: kv
    real(kind=8)            :: drv
! ----------------------------------------------------------------------
    if (self%active) then
        drv = dvsc_dka(self,kv)
    else
        drv = 1
    end if
end function dkv_dka



! ----------------------------------------------------------------------
!  Compute viscosity vsc from kv or from dka
! ----------------------------------------------------------------------

function f_vsc(self,dka,kv) result(vsc)
    implicit none
    type(VISCO),intent(in)  :: self
    real(kind=8),intent(in),optional :: dka
    real(kind=8),intent(in),optional :: kv
    real(kind=8)            :: vsc
! ----------------------------------------------------------------------

    ! one and one only among dka and kv is given
    ASSERT(present(dka) .eqv. .not.present(kv))
    
    ! Selection of the appropriate variable
    if (present(dka)) then
        vsc = dka_to_vsc(self,dka)
    else if (self%active) then
        vsc = kv
    else
        vsc = dka_to_vsc(self,kv)
    end if
    
end function f_vsc



! ----------------------------------------------------------------------
!  Compute the derivative of viscosity with respect to kv
! ----------------------------------------------------------------------
function dkv_vsc(self,kv) result (drv)
    implicit none
    type(VISCO),intent(in)  :: self
    real(kind=8),intent(in) :: kv
    real(kind=8)            :: drv
! ----------------------------------------------------------------------

    ! Selection of the appropriate variable
    if (self%active) then
        drv = 1
    else
        drv = ddka_vsc(self,kv)
    end if
    
end function dkv_vsc



! ----------------------------------------------------------------------
!  Find the value dka such as dka_vsc(dka) = h0
! ----------------------------------------------------------------------
function solve_slope_dka(self,h0) result (dka)
    implicit none
    type(VISCO),intent(in)  :: self
    real(kind=8),intent(in) :: h0
    real(kind=8)            :: dka
! ----------------------------------------------------------------------
    dka = (self%v0*self%q/h0)**(1/(1-self%q))
end function solve_slope_dka




end module visc_norton_module
