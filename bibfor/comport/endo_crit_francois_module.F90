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

module endo_crit_francois_module

    use tenseur_dime_module,  only: rs, kron
    use pilotage_util_module, only: SolvePosValCst
    
    implicit none
    private
    public:: CRITERION, MATERIAL, Init, SetQuad, ComputeQuad, DerivateQuad, &
             IsQuadLarger, SetPathFollowing, ComputePathFollowing, &
             BoundsCstPathFollowing

#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/lcexpo.h"
#include "asterfort/lcvalp.h"
#include "asterfort/lcvpbo.h"
#include "asterc/r8prem.h"


! --------------------------------------------------------------------


    ! Material characteristics
    type MATERIAL
        real(kind=8) :: lambda,deuxmu,gam0,sig0,bet0
    end type MATERIAL


    ! attribute state: 0=not defined, 1=allocated, 2=argument set, 3=computed    
    type CRITERION
        integer                              :: stateQuad = 0
        integer                              :: statePath = 0
        integer                              :: exception = 0
        integer                              :: ndimsi    = 0
        type(MATERIAL)                       :: mat
        integer                              :: itemax
        real(kind=8)                         :: cvquad
        real(kind=8),dimension(:),allocatable:: sig
        real(kind=8),dimension(:),allocatable:: eps0
        real(kind=8),dimension(:),allocatable:: eps1
        real(kind=8)                         :: lcst
        real(kind=8),dimension(3)            :: vp
        real(kind=8)                         :: chi
    end type CRITERION
    


contains


! =====================================================================
!  OBJECT CREATION AND VECTOR ALLOCATION
! =====================================================================

function Init(ndimsi,mat,itemax,cvquad) result(self)
    implicit none
    integer,intent(in)        :: ndimsi
    type(MATERIAL), intent(in):: mat
    integer,intent(in)        :: itemax
    real(kind=8),intent(in)   :: cvquad
    type(CRITERION)         :: self
! ---------------------------------------------------------------------    
!  ndimsi  size of the strain and stress vectors (2*ndim)
!  mat     material characteristics
!  itemax  maximal number of iterations for the solver
!  cvquad  accuracy for the computation of Q: abs(delta_Q) < cvquad
! ---------------------------------------------------------------------

    self%stateQuad  = 1
    self%statePath  = 1
    self%ndimsi     = ndimsi
    self%mat        = mat
    self%cvquad     = cvquad
    self%itemax     = itemax
        
    allocate(self%sig(ndimsi))
    allocate(self%eps0(ndimsi))
    allocate(self%eps1(ndimsi))

    
end function Init



! =====================================================================
!  SET STRAIN VALUE FOR THE COMPUTATION OF THE QUAD FUNCTION Q
! =====================================================================

subroutine SetQuad(self,eps) 
    implicit none
    type(CRITERION),intent(inout)       :: self
    real(kind=8),dimension(:),intent(in):: eps
! ---------------------------------------------------------------------    
!  eps     valeur de l'argument eps(1:ndimsi)
! ---------------------------------------------------------------------
    real(kind=8):: treps
    real(kind=8),dimension(self%ndimsi):: kr
! ---------------------------------------------------------------------    
    ASSERT(self%stateQuad .ge. 1)
    self%stateQuad  = 2

    kr       = kron(self%ndimsi) 
    treps    = sum(eps(1:3))
    self%sig = self%mat%lambda*treps*kr + self%mat%deuxmu*eps

end subroutine SetQuad



! =====================================================================
!  COMPUTE THE QUAD FUNCTION Q
! =====================================================================

function ComputeQuad(self) result(quad)
    implicit none
    type(CRITERION),intent(inout):: self
    real(kind=8)                 :: quad
! ---------------------------------------------------------------------
    real(kind=8):: precx1
! ---------------------------------------------------------------------
    ASSERT(self%stateQuad .ge. 2)
    self%stateQuad = 3
    

!  PRECISION RECHERCHEE SUR CHI * DCHI
    precx1 = 0.5d0*self%cvquad    

    call lcvalp(rs(6,self%sig), self%vp)

    self%chi = ComputeChi(self, precx1)
    if (self%exception .eq. 1) then
        self%stateQuad = 2
        goto 999
    end if
    
    quad = self%chi**2
    
    
999 continue
end function ComputeQuad



! =====================================================================
!  DERIVATE THE QUAD FUNCTION Q
! =====================================================================

function DerivateQuad(self) result (deps_quad)
    implicit none
    type(CRITERION),intent(inout):: self
    real(kind=8)                 :: deps_quad(size(self%sig))
! ---------------------------------------------------------------------
    real(kind=8):: coef,trchid,dchids(size(self%sig)),r8bid
    real(kind=8),dimension(self%ndimsi):: kr
! ---------------------------------------------------------------------
    ASSERT(self%stateQuad .ge. 2)
    
    kr = kron(self%ndimsi) 
    
    if (self%stateQuad .eq. 2) then 
        r8bid = ComputeQuad(self)
        ASSERT(self%exception .eq. 0)
    end if
    
    if (self%chi .ne. 0) then
        dchids     = DerivateChi(self)
        coef       = 2 * self%chi
        trchid     = sum(dchids(1:3))
        deps_quad = coef*(self%mat%lambda*trchid*kr + self%mat%deuxmu*dchids)
    else
        deps_quad = 0
    endif

end function DerivateQuad



! =====================================================================
!  Check whether Q(eps) > bnd  without computing Q(eps)
! =====================================================================

function IsQuadLarger(self,bnd) result(larger)
    implicit none
    type(CRITERION),intent(inout):: self
    real(kind=8),intent(in)      :: bnd
    aster_logical                :: larger
! ---------------------------------------------------------------------
! in bnd    the bound which Q(eps) is compared to
! ---------------------------------------------------------------------
    ASSERT(self%stateQuad .ge. 2)
    call lcvalp(rs(6,self%sig), self%vp)
    
    larger = IsCriterionLarger(self,sqrt(bnd))

end function IsQuadLarger



! =====================================================================
!  COMPUTE CHI
! =====================================================================

function ComputeChi(self,precx1) result(chi)
    implicit none
    type(CRITERION),intent(inout):: self
    real(kind=8),intent(in)      :: precx1
    real(kind=8)                 :: chi
! ---------------------------------------------------------------------
! in  precx1  required accuracy : chi*dchi < precx1
! ---------------------------------------------------------------------
    integer      :: iter
    real(kind=8) :: norsig, n(3), clin, ymax, y, expo(3), norexp, f, df 
    real(kind=8) :: coefbe, prectr, precy3, yt, ft
! ---------------------------------------------------------------------

!  initialisation
    prectr = 1.d-3*self%mat%gam0
    coefbe = 3*self%mat%bet0**2-1.d0/3.d0


!  normalisation
    norsig = sqrt(dot_product(self%vp,self%vp))
    if (norsig .lt. self%mat%sig0 * r8prem()) then
        chi = 0
        goto 999
    endif
    n = self%vp/norsig


!  linear coefficient
    clin = sqrt(1 + coefbe*sum(n)**2)


!  upper bound
    ymax = self%mat%gam0/clin
    y = ymax
    if (n(1) .gt. 0) y = min(y,log(self%mat%gam0)/n(1))


!  Accuracy
    precy3 = (self%mat%sig0/norsig)**2 * precx1


! ---------------------------------------------------------------------
!  Solve by Newton method
! ---------------------------------------------------------------------
    
    do iter = 1, self%itemax
        expo   = exp(2*y*n)
        norexp = sqrt(sum(expo))

        f = clin*y + norexp - self%mat%gam0
        df = clin + dot_product(n,expo) / norexp

        if (abs(f) .le. prectr) then
            yt = y - sign(1.d0,f)*precy3*y**3
            if (yt<=0 .or. yt>=ymax) goto 20
            ft = clin*yt + sqrt(sum(exp(2*yt*n))) - self%mat%gam0
            if (ft*f .le. 0) goto 20
        end if

        y = y - f/df
    end do

!  Failed
    self%exception = 1
    goto 999

!  Success
20  continue
    chi = norsig/(y*self%mat%sig0)


999 continue
end function ComputeChi



! =====================================================================
!  Compute the derivative of chi with respect to sigma
! =====================================================================

function DerivateChi(self) result(dchids)
    implicit none
    type(CRITERION),intent(in):: self
    real(kind=8)              :: dchids(self%ndimsi)
! ---------------------------------------------------------------------
    integer,parameter      :: mexp=6, factom=720
    real(kind=8),parameter :: srac2=sqrt(0.5d0)
! ---------------------------------------------------------------------
    integer :: nexp
    real(kind=8) :: sbnor, sbtr, coefbe, sbtnor,  preexp, vpmax, targ,enor, h
    real(kind=8),dimension(self%ndimsi) :: sb,u,e2
    real(kind=8),dimension(6)         :: e
    real(kind=8),dimension(self%ndimsi):: kr
! ---------------------------------------------------------------------

    
!  initialisation
    preexp = self%cvquad*1.d-1
    coefbe = 3*self%mat%bet0**2-1.d0/3.d0
    sb     = self%sig/self%mat%sig0
    sbnor  = sqrt(dot_product(sb,sb))
    u      = self%sig/self%chi/self%mat%sig0
    kr     = kron(self%ndimsi) 


!  Compute n tilde
    sbtr   = sum(sb(1:3))
    sbtnor = sqrt(coefbe*sbtr**2 + sbnor**2)


!  compute exp(u) and its norm
    vpmax = maxval(abs(self%vp/self%chi/self%mat%sig0))
    targ = (factom*preexp)**(1.d0/mexp)
    nexp = merge(0, int(1 + log(vpmax/targ)/log(2.d0)/(1-1.d0/mexp)), vpmax.lt.targ)
    call lcexpo(rs(6,u), e, mexp, nexp)
    enor = sqrt(dot_product(e,e))


!  negligible exponential 
    if (enor*sbnor .le. sbtnor*preexp*1.d-3) then
        dchids = self%chi/sbtnor**2/self%mat%sig0 * (sb+coefbe*sbtr*kr)
        goto 999
    end if


!  compute exp(2.u)
    e2(1) = e(1)*e(1) + 0.5d0*e(4)*e(4) + 0.5d0*e(5)*e(5)
    e2(2) = 0.5d0*e(4)*e(4) + e(2)*e(2) + 0.5d0*e(6)*e(6)
    e2(3) = 0.5d0*e(5)*e(5) + 0.5d0*e(6)*e(6) + e(3)*e(3)
    e2(4) = e(1)*e(4) + e(4)*e(2) + srac2*e(5)*e(6)
    
    if (size(e2).eq.6) then
        e2(5) = e(1)*e(5) + srac2*e(4)*e(6) + e(5)*e(3)
        e2(6) = srac2*e(4)*e(5) + e(2)*e(6) + e(6)*e(3)
    end if


!  compute tangent tensor
    h = sbtnor + sum(e2*sb)/enor
    dchids = self%chi/h/self%mat%sig0*((sb+coefbe*sbtr*kr)/sbtnor + e2/enor)


999 continue
end function DerivateChi



! =====================================================================
!  CHECK WHETHER THE CRITERION IS POSITIVE
! =====================================================================

function IsCriterionLarger(self,star) result(larger)
    implicit none
    type(CRITERION),intent(inout):: self
    real(kind=8),intent(in)      :: star
    aster_logical                :: larger
! ---------------------------------------------------------------------
! in  star  Compute fsig(sig/star) -> is fsig > 0
! ---------------------------------------------------------------------
    real(kind=8) :: sig_nor(3),sig_qua(3),sig_exp(3),f_sig,f_qua,smax
! ---------------------------------------------------------------------

    sig_nor = self%vp/(star*self%mat%sig0)
    smax    = maxval(sig_nor)
    sig_qua = sig_nor + (self%mat%bet0-1.d0/3.d0)*sum(sig_nor)
    f_qua   = sqrt(dot_product(sig_qua,sig_qua)) - self%mat%gam0
    
    ! Avoid the computation of the exponential (when too large)
    if (f_qua .ge. 0) then
        larger = ASTER_TRUE
        goto 999
    end if
    
    ! Avoid the computation of the exponential (when too large)
    if (smax.ge.log(-f_qua)) then
        larger = ASTER_TRUE
        goto 999
    end if
    
    ! Compute the criterion
    sig_exp = exp(sig_nor)
    f_sig   = f_qua + sqrt(dot_product(sig_exp,sig_exp))
    larger  = f_sig.ge.0
    
999 continue
end function IsCriterionLarger



! =====================================================================
!  SET STRAIN VALUES FOR PATH FOLLOWING
! =====================================================================

subroutine SetPathFollowing(self,eps0,eps1,lcst) 
    implicit none
    type(CRITERION),intent(inout)       :: self
    real(kind=8),intent(in)             :: lcst
    real(kind=8),dimension(:),intent(in):: eps0,eps1
! ---------------------------------------------------------------------    
!  eps0    constant term for the strain (eps = eps0 + eta*eps1)
!  eps1    linear term for the strain   (eps = eps0 + eta*eps1)
!  lcst    constant rhs term ( path foll. equ. Q(eps) + lcst = 0)
! ---------------------------------------------------------------------

    ASSERT(self%statePath .ge. 1)
    self%statePath = 2
    
    self%eps0 = eps0
    self%eps1 = eps1
    self%lcst = lcst

end subroutine SetPathFollowing



! =====================================================================
!  COMPUTE PATH_FOLLOWING(ETA) AND ITS DERIVATIVE 
! =====================================================================

subroutine ComputePathFollowing(self, eta, pff, deta_pff)
    implicit none
    type(CRITERION),intent(inout):: self
    real(kind=8),intent(in)      :: eta
    real(kind=8), intent(out)    :: pff, deta_pff
! ---------------------------------------------------------------------
! eta       argument of the path-following function
! pff       path-following function Q(eps) + lcst
! deta_pff  derivative of the path-following function 
! ---------------------------------------------------------------------
    real(kind=8):: quad,deps_quad(self%ndimsi)
! ---------------------------------------------------------------------
    
    ASSERT(self%statePath .ge. 2)
    
    call SetQuad(self, self%eps0 + eta*self%eps1) 
    quad = ComputeQuad(self)
    if (self%exception .ne. 0) goto 999
    deps_quad = DerivateQuad(self)   
    
    pff      = quad + self%lcst
    deta_pff = dot_product(deps_quad,self%eps1)

999 continue
end subroutine ComputePathFollowing



! =====================================================================
!  BOUNDS ON ETA FOR PATH - FOLLOWING EQUATION : CHI**2 + LCST = 0
! =====================================================================

subroutine BoundsCstPathFollowing(self, etamin, etamax, empty, etam, etap)
    implicit none
    type(CRITERION),intent(in):: self
    real(kind=8), intent(in)  :: etamin, etamax
    aster_logical, intent(out):: empty
    real(kind=8), intent(out) :: etam, etap
! ---------------------------------------------------------------------
! etamin    initial lower bound
! etamax    initial upper bound
! empty     return code: true=no solution, false=bounds
! etam      new lower bound
! etap      new upper bound
! ---------------------------------------------------------------------
    aster_logical :: empty1, empty2
    integer :: nsol, nsol1, nsol2, sgn(2), sgn1, sgn2, ptr
    real(kind=8) :: ts0(self%ndimsi), ts1(self%ndimsi), s0(3), s1(3), coefbe
    real(kind=8) :: s0s0, s0s1, s1s1, trs0, trs1, q0, q1, q2, sol(2), sol1, sol2
    real(kind=8) :: am, ap, b
    real(kind=8),dimension(self%ndimsi):: kr
! ---------------------------------------------------------------------

    ASSERT(self%statePath .ge. 2)
    
    
    ! initialisation
    
    kr     = kron(self%ndimsi) 
    etam   = etamin
    etap   = etamax
    coefbe = 3*self%mat%bet0**2-1.d0/3.d0


    ! valeurs propres des contraintes normalisees

    ts0 = (self%mat%lambda*sum(self%eps0(1:3))*kr + self%mat%deuxmu*self%eps0)/self%mat%sig0
    ts1 = (self%mat%lambda*sum(self%eps1(1:3))*kr + self%mat%deuxmu*self%eps1)/self%mat%sig0
    s0s0 = dot_product(ts0,ts0)
    s0s1 = dot_product(ts0,ts1)
    s1s1 = dot_product(ts1,ts1)

    trs0 = sum(ts0(1:3))
    trs1 = sum(ts1(1:3))
    call lcvalp(rs(6,ts0), s0)
    call lcvalp(rs(6,ts1), s1)


    ! bornes issues de la partie quadratique du critere

    q2 = (s1s1 + coefbe*trs1*trs1)/self%mat%gam0**2
    q1 = 2*(s0s1 + coefbe*trs0*trs1)/self%mat%gam0**2 
    q0 = (s0s0 + coefbe*trs0*trs0)/self%mat%gam0**2 + self%lcst

    call lcvpbo(sqrt(q2), 0.d0, q0, q1, etam,&
                etap, empty, nsol, sol, sgn)
    if (empty) goto 999

    ! Synthese des bornes pour le minorant quadratique
    if (nsol .eq. 1) then
        if (sgn(1) .eq. -1) then
            etam = sol(1)
        else
            etap = sol(1)
        endif
    else if (nsol.eq.2) then
        etam=sol(1)
        etap=sol(2)
    endif


    ! Bornes issues du terme dominant de l'exponentiel

    am = s1(3)/abs(log(self%mat%gam0))
    ap = s1(1)/abs(log(self%mat%gam0))
    b  = s0(3)/abs(log(self%mat%gam0))


    ! alternative fixee (positive) dans le choix du minorant de la vp
    if (etam.ge.0) then
        call SolvePosValCst(ap, b, self%lcst, etam, etap, empty, nsol, sol(1), sgn(1))


    ! alternative fixee (negative) dans le choix du minorant de la vp
    else if (etap.le.0) then
        call SolvePosValCst(am, b, self%lcst, etam, etap, empty, nsol, sol(1), sgn(1))


    ! alternative avec changement de signe
    else
        call SolvePosValCst(am, b, self%lcst, etam, 0.d0, empty1, nsol1, sol1, sgn1)
        call SolvePosValCst(ap, b, self%lcst, 0.d0, etap, empty2, nsol2, sol2, sgn2)
                    
        nsol = nsol1+nsol2
        empty = empty1 .and. empty2
        if (empty) goto 999

        ptr = 0
        if (nsol1.eq.1) then
            ptr = ptr+1
            sol(ptr)=sol1
            sgn(ptr)=sgn1
        end if
        if (nsol2.eq.1) then
            ptr = ptr+1
            sol(ptr)=sol2
            sgn(ptr)=sgn2
        end if
    endif


    ! Synthese des bornes pour le terme exponentiel
    if (nsol .eq. 1) then
        if (sgn(1) .eq. -1) then
            etam = sol(1)
        else
            etap = sol(1)
        endif
    else if (nsol.eq.2) then
        etam=sol(1)
        etap=sol(2)
    endif


999 continue
end subroutine BoundsCstPathFollowing



end module endo_crit_francois_module
