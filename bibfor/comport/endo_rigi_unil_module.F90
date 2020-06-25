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

module endo_rigi_unil_module

    use tenseur_dime_module, only: kron, rs
    
    implicit none
    private
    public:: MATERIAL, ComputeStress, ComputeEnergy

#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/lcvalp.h"
#include "asterfort/lcesme.h"

! --------------------------------------------------------------------

    ! Material characteristics

    type MATERIAL
        real(kind=8) :: lambda,deuxmu,regam
    end type MATERIAL



contains

! =====================================================================
!  CONTRAINTES ET RIGIDITE AVEC RESTAURATION DE RIGIDITE 
! =====================================================================

subroutine ComputeStress(mat,eps,rigi,elas,prece,sigpos,signeg,de_spos,de_sneg)
    implicit none

    type(MATERIAL),intent(in):: mat
    aster_logical,intent(in) :: rigi,elas
    real(kind=8),intent(in)  :: eps(:),prece
    real(kind=8),intent(out) :: sigpos(:),signeg(:),de_spos(:,:),de_sneg(:,:)
! ---------------------------------------------------------------------
! mat       material characteristics
! eps       deformation
! rigi      calcul ou non des matrices tangentes
! elas      mode secant (.true.) ou tangent (.false.)
! prece     relative accuracy with respect to the strain components
! sigpos    contrainte positive (traction)
! signeg    contrainte negative (compression)
! de_spos   derivee de la contrainte sigpos / deformation
! de_sneg   derivee de la contrainte signeg / deformation
! ---------------------------------------------------------------------
    integer:: i
    real(kind=8):: para(2)
    real(kind=8)::treps,unitr,dertr
    real(kind=8),dimension(3):: eigeps
    real(kind=8),dimension(size(eps)):: unieps,sigall
    real(kind=8),dimension(size(eps),size(eps)):: dereps,de_sall
    real(kind=8),dimension(6)::unieps_6
    real(kind=8),dimension(6,6)::dereps_66
    real(kind=8),dimension(size(eps)):: kr
    real(kind=8), parameter::safe=1.d2
! ---------------------------------------------------------------------


!   Initialisation
    kr = kron(size(eps))
    para(1) = mat%regam
    para(2) = merge(1.0d0,0.d0,elas)
    treps = sum(eps(1:3))


!   Unilateral function (negative part)
    call lcvalp(rs(6,eps),eigeps)
    call NegPart(treps,para,unitr,dertr)
    call lcesme(rs(6,eps),eigeps,para,NegPart,prece/safe,unieps_6,dereps_66)
    unieps = unieps_6(1:size(eps))
    dereps = dereps_66(1:size(eps),1:size(eps))
    

!   Stress
    sigall = mat%lambda*treps*kr + mat%deuxmu*eps
    signeg = mat%lambda*unitr*kr + mat%deuxmu*unieps
    sigpos = sigall - signeg


!   Derivatives
    if (rigi) then

!      Matrice totale (Hooke)
        de_sall = 0.d0
        de_sall(1:3,1:3) = mat%lambda
        do i = 1,size(eps)
            de_sall(i,i) = de_sall(i,i) + mat%deuxmu
        end do

!      Matrices negative et positive
        de_sneg = mat%deuxmu*dereps
        de_sneg(1:3,1:3) = de_sneg(1:3,1:3) + mat%lambda*dertr
        de_spos = de_sall - de_sneg
    end if

end subroutine ComputeStress




! =====================================================================
!  ENERGIE AVEC RESTAURATION DE RIGIDITE 
! =====================================================================

subroutine ComputeEnergy(mat,eps,wpos,wneg)
    implicit none

    type(MATERIAL),intent(in):: mat
    real(kind=8),intent(in)  :: eps(:)
    real(kind=8),intent(out) :: wpos,wneg
! ---------------------------------------------------------------------
! mat       material characteristics
! eps       strain
! wpos      tensile contribution to the energy
! wneg      compressive contribution to the energy
! ---------------------------------------------------------------------
    integer     :: i
    real(kind=8):: para(2)
    real(kind=8):: treps,trNhs,wall
    real(kind=8),dimension(3):: eigeps,eigNhs
! ---------------------------------------------------------------------


!   Initialisation
    para(1) = mat%regam
    para(2) = 0.d0
    
!   Strain characteristics and total energy
    treps = sum(eps(1:3))
    call lcvalp(rs(6,eps),eigeps)
    wall = 0.5d0*(mat%lambda*treps**2 + mat%deuxmu*sum(eigeps**2))


!   Negative and positive parts
    trNhs  = NegHalfSquare(treps,para)
    eigNhs = [(NegHalfSquare(eigeps(i),para), i=1,size(eigeps))]
    wneg   = mat%lambda * trNhs + mat%deuxmu * sum(eigNhs)
    wpos   = wall - wneg


end subroutine ComputeEnergy




! =====================================================================
!   SMOOTHED NEGATIVE HALF SQUARE FUNCTION 
!   f(x) approximate 0.5 * <-x>**2
!     f(x) = 0.5 * x**2 * exp(1/(gamma*x)) if x<0
!     f(x) = 0                             if x>0
! =====================================================================

function NegHalfSquare(x,p) result(nhs)
    implicit none

    real(kind=8),intent(in):: x,p(:)
    real(kind=8)           :: nhs
! ---------------------------------------------------------------------
! x:   array argument (the function is applied to each x(i))
! p:   additional parameters
!        p(1) = gamma (smoothing parameter)
!        p(2) unused
! ---------------------------------------------------------------------
    real(kind=8) :: ga
! ---------------------------------------------------------------------

    ASSERT(size(p).eq.2)   
    ga  = p(1)
    if (ga*x .ge. -1.d-3) then
        nhs = 0.d0
    else
        nhs = 0.5d0 * x**2 * exp(1/(ga*x))
    end if


end function NegHalfSquare




! =====================================================================
!   SMOOTHED UNILATERAL FUNCTION AND ITS DERIVATIVE
!     f(x) = (x - 0.5/gamma) * exp(1/(gamma*x)) if x<0
!     f(x) = 0                                  if x>0
! =====================================================================

subroutine NegPart(x,p,val,der)
    implicit none

    real(kind=8),intent(in) :: x,p(:)
    real(kind=8),intent(out):: val,der
! ---------------------------------------------------------------------
! x:   argument
! p:   additional parameters
!        p(1) = gamma (smoothing parameter)
!        p(2) = 0 si secant, 1 si tangent
! val: f(x)
! der: f'(x) ou f(x)/x si secant 
! ---------------------------------------------------------------------
    aster_logical:: elas
    real(kind=8) :: regam
! ---------------------------------------------------------------------

    ASSERT(size(p).eq.2)   
    regam = p(1)
    elas  = p(2).gt.0.5d0

    if (x*regam.ge.-1.d-3) then
        val = 0
        der = 0
    else
        val = (x-0.5d0/regam) * exp(1/(regam*x))
        der = merge(val/x,(1 - (regam*x-0.5d0)/(regam*x)**2) * exp(1/(regam*x)),elas)
    end if


end subroutine NegPart




end module endo_rigi_unil_module
