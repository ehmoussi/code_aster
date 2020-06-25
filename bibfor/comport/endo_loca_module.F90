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

module endo_loca_module

    use scalar_newton_module,       only: &
            newton_state, &
            utnewt
    
    use  tenseur_dime_module,       only: &
            proten 
            
    use endo_crit_francois_module,  only: &
            CRITERION, &
            CRIT_MAT                    => MATERIAL, &
            CritInit                    => Init, &
            SetQuad, &
            ComputeQuad, &
            DerivateQuad, &
            IsQuadLarger, &
            SetPathFollowing, &
            BoundsCstPathFollowing, &
            ComputePathFollowing
             
    use endo_rigi_unil_module,      only: &
            UNIL_MAT => MATERIAL, &
            ComputeStress, &
            ComputeEnergy
            
    implicit none
    private
    public:: CONSTITUTIVE_LAW, Init, Integrate, PathFollowing

#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/rcvalb.h"
#include "asterfort/utmess.h"
#include "asterc/r8pi.h"

! --------------------------------------------------------------------

    ! Material characteristics
    type MATERIAL
        real(kind=8)   :: kappa
        real(kind=8)   :: m0
        real(kind=8)   :: d1
        real(kind=8)   :: r
        real(kind=8)   :: sigc
        type(CRIT_MAT) :: cmat
        type(UNIL_MAT) :: unil
    end type MATERIAL

    
    ! Shared attibutes through the global variable self
    type CONSTITUTIVE_LAW
        integer       :: exception = 0
        aster_logical :: elas,rigi,resi,pilo
        integer       :: ndimsi,itemax
        real(kind=8)  :: cvuser,deltat
        type(MATERIAL):: mat
    end type CONSTITUTIVE_LAW
       

    ! Post-treatment results
    type POST_TREATMENT
        real(kind=8)  :: damsti
        real(kind=8)  :: welas
        real(kind=8)  :: wdiss
    end type POST_TREATMENT
    
    
    
contains


! =====================================================================
!  OBJECT CREATION AND INITIALISATION
! =====================================================================

function Init(ndimsi, option, fami, kpg, ksp, imate, itemax, precvg, deltat) &
    result(self)
        
    implicit none
    
    integer,intent(in)          :: kpg, ksp, imate, itemax, ndimsi
    real(kind=8), intent(in)    :: precvg, deltat
    character(len=16),intent(in):: option
    character(len=*),intent(in) :: fami
    type(CONSTITUTIVE_LAW)      :: self
! ---------------------------------------------------------------------
! ndimsi    symmetric tensor dimension (2*ndim)
! option    computation option
! fami      Gauss point set
! kpg       Gauss point number
! ksp       Layer number (for structure elements)
! imate     material pointer
! itemax    max number of iterations for the solver
! precvg    required accuracy (with respect to stress level))
! deltat    time increment (instap - instam)
! ---------------------------------------------------------------------
            
    self%elas   = option.eq.'RIGI_MECA_ELAS' .or. option.eq.'FULL_MECA_ELAS'
    self%rigi   = option.eq.'RIGI_MECA_TANG' .or. option.eq.'RIGI_MECA_ELAS' &
             .or. option.eq.'FULL_MECA' .or. option.eq.'FULL_MECA_ELAS'
    self%resi   = option.eq.'FULL_MECA_ELAS' .or. option.eq.'FULL_MECA'      &
             .or. option.eq.'RAPH_MECA'
    self%pilo   = option.eq.'PILO_PRED_ELAS'
    
    ASSERT (self%rigi .or. self%resi .or. self%pilo)
    
    ! On force la matrice secante en prediction
    if (self%rigi .and. .not. self%resi) self%elas=ASTER_TRUE
    
    self%ndimsi = ndimsi
    self%itemax = itemax
    self%cvuser = precvg
    self%deltat = deltat
    self%mat    = GetMaterial(self,fami,kpg,ksp,imate)
                
end function Init


    
! =====================================================================
!  INTEGRATION OF ENDO_LOCA_EXP (MAIN ROUTINE)
! =====================================================================


subroutine Integrate(self, epsm, deps, vim, sig, vip, dsde)

    implicit none

    type(CONSTITUTIVE_LAW), intent(inout):: self
    real(kind=8), intent(in)    :: epsm(:), deps(:), vim(:)
    real(kind=8),intent(out)    :: sig(:), vip(:), dsde(:,:)
! ----------------------------------------------------------------------
! epsm  strain at the beginning of the time step
! deps  strain increment
! vim   internal variables at the beginning of the time step
! sig   stress at the end of the time step
! vip   internal variables at the end of the time step
! dsde  tangent matrix (ndimsi,ndimsi)
! ----------------------------------------------------------------------
    integer             :: state
    real(kind=8)        :: be
    real(kind=8)        :: eps(self%ndimsi)
    type(POST_TREATMENT):: postm, post
! ---------------------------------------------------------------------

! Current strain
    eps  = epsm + deps


! unpack internal variables
    be     = vim(1)
    state  = nint(vim(2))
    postm  = POST_TREATMENT(damsti=vim(3), welas=vim(4), wdiss=vim(5))


! damage behaviour integration
    call ComputeDamage(self, eps, be, state, sig, dsde)
    if (self%exception .ne. 0) goto 999


! viscous regularisation


! Post-treatments
    if (self%resi) post = PostTreatment(self, eps, deps, be, postm)
    

! pack internal variables 
    if (self%resi) then
        vip(1) = be
        vip(2) = state
        vip(3) = post%damsti
        vip(4) = post%welas
        vip(5) = post%wdiss
    end if


999 continue    
end subroutine Integrate



! =====================================================================
!  MATERIAL CHARACTERISTICS-> store in mat global variable
! =====================================================================

function GetMaterial(self,fami,kpg,ksp,imate) result(mat)
    
    implicit none

    type(CONSTITUTIVE_LAW), intent(inout):: self
    integer,intent(in)                   :: kpg, ksp, imate
    character(len=*),intent(in)          :: fami
    type(MATERIAL)                       :: mat
! ---------------------------------------------------------------------
! fami      Gauss point set
! kpg       Gauss point number
! ksp       Layer number (for structure elements)
! imate     material pointer
! ---------------------------------------------------------------------
    integer,parameter:: nbel=2, nben=6
! ----------------------------------------------------------------------
    integer :: iok(nbel+nben)
    real(kind=8) :: valel(nbel), valen(nben)
    character(len=16) :: nomel(nbel), nomen(nben)
    real(kind=8):: lambda,deuxmu,nu,ec,sc,s0,b0,tx,ty,ex,ey,g0,p,pi,m0,d1,r,cf
! ----------------------------------------------------------------------
    data nomel /'E','NU'/
    data nomen /'KAPPA','P','SIGC','SIG0','BETA0','REST_RIGIDITE'/
! ----------------------------------------------------------------------

!  Elasticity
    call rcvalb(fami,kpg,ksp,'+',imate,' ','ELAS',0,' ',[0.d0],nbel,nomel,valel,iok,2)

    lambda = valel(1)*valel(2)/((1+valel(2))*(1-2*valel(2)))
    deuxmu = valel(1)/(1+valel(2))
    nu     = valel(2)
    ec     = lambda+deuxmu


!   Damage parameters
    call rcvalb(fami,kpg,ksp,'+',imate,' ','ENDO_LOCA_EXP',0,' ',[0.d0],nben,nomen,valen,iok,2)

    sc = valen(3)
    
    s0 = valen(4)
    b0 = valen(5)
    cf = lambda/ec
    tx = (1  + (b0-1.d0/3.d0)*(1+2*cf))*sc/s0
    ty = (cf + (b0-1.d0/3.d0)*(1+2*cf))*sc/s0
    ex = exp(sc/s0)
    ey = exp(cf*sc/s0)
    g0 = sqrt(tx**2+2*ty**2) + sqrt(ex**2+2*ey**2) 

    p  = valen(2)
    pi = r8pi()
    m0 = 1.5d0*pi*(p+2)**(-1.5d0)
    d1 = 0.75d0*pi*sqrt(1+p)
    r  = (2*(d1-1)-m0)/(2-m0)


!   Storage
    mat%unil%lambda = lambda
    mat%unil%deuxmu = deuxmu
    mat%unil%regam  = valen(6)
    
    mat%cmat%lambda = lambda
    mat%cmat%deuxmu = deuxmu
    mat%cmat%gam0   = g0
    mat%cmat%sig0   = s0
    mat%cmat%bet0   = b0

    mat%kappa = valen(1)
    mat%m0    = m0
    mat%d1    = d1
    mat%r     = r
    mat%sigc  = sc

    if (mat%kappa * mat%m0 .lt. 2) &
        call utmess('F', 'COMPOR1_98', sr=mat%m0)
    
end function GetMaterial



! =====================================================================
!  DAMAGE COMPUTATION AND TANGENT OPERATOR (ACCORDING TO RIGI AND RESI)
! =====================================================================

subroutine ComputeDamage(self, eps, be, state, sig, dsde)
    
    implicit none

    type(CONSTITUTIVE_LAW), intent(inout):: self
    real(kind=8), intent(in)             :: eps(:)
    integer,intent(inout)                :: state  
    real(kind=8),intent(inout)           :: be  
    real(kind=8),intent(out)             :: sig(:), dsde(:,:)
! ---------------------------------------------------------------------
! eps   strain at the end of the time step
! be    damage at the beginning (in) of the time-step then its end (out)
! state damage state for the former (in) then the current (out) time-step
! sig   stress at the end of the time step
! dsde  tangent matrix (ndimsi,ndimsi)
! ---------------------------------------------------------------------
    real(kind=8),parameter:: cvtole=1.d-3      
    integer     :: iter
    real(kind=8),dimension(self%ndimsi):: sigpos, signeg, deps_quad
    real(kind=8),dimension(self%ndimsi,self%ndimsi):: deps_sigpos, deps_signeg
    real(kind=8):: cvsig,cveps,cvbe,cvquad,cvequ,norpos,hn,db_hn,db_hu,db_phin,majB,majQ
    real(kind=8):: quad,equ,db_equ,phi,stiff
    real(kind=8):: db_B, db_phi
    type(newton_state):: mem
    type(CRITERION)   :: crit
! ---------------------------------------------------------------------

    ! Expected accuracy for the stress and the strain
    cvsig = 0.5d0 * self%mat%sigc * self%cvuser
    cveps = cvsig / (self%mat%unil%lambda + self%mat%unil%deuxmu)


    ! Nonlinear elastic stresses and tangent (or secant) matrices
    call ComputeStress(self%mat%unil, eps, self%rigi, self%elas, cveps, &
            sigpos, signeg, deps_sigpos, deps_signeg)

    
    ! Convergence thresholds
    norpos  = sqrt(dot_product(sigpos,sigpos))
    hn      = Fh(self,be)
    db_hn   = Db_Fh(self,be)
    db_hu   = Db_Fh(self,1.d0)
    db_phin = Db_Fphi(self,be)
    
    majB    = 1/hn + (1-be)*db_hu/hn**2
    majQ    = 0.5d0*db_phin
    
    if (norpos .gt. cvsig/majB/cvtole) then
        cvbe = cvsig/majB/norpos
    else
        cvbe = cvtole
    end if
    
    cvquad = min(majQ*cvbe, cvtole)
    cvequ  = min(majQ*cvbe, cvtole)


    ! Strain driving force and its derivative if required
    crit = CritInit(self%ndimsi,self%mat%cmat,self%itemax,cvquad)
    call SetQuad(crit,eps)
    
    
    ! Damage computation (if required)
    if (self%resi) then
    
        ! Already saturated point
        if (state.eq.2) then
            goto 200
        end if

        ! Saturated point: fast check (for large eps)
        if (IsQuadLarger(crit,Fphi(self,1.d0))) then
            state = 2
            be    = 1.d0
            goto 200
        end if
        
        quad = ComputeQuad(crit)    
        if (crit%exception .ne. 0) then
            self%exception = crit%exception
            goto 999
        end if
        
        ! Elastic regime
        if (quad-Fphi(self,be) .le. cvequ) then
            state = 0
            goto 200
        end if
        
        ! Saturated point
        if (quad-Fphi(self,1.d0) .ge. -cvequ) then
            state = 2
            be    = 1.d0
            goto 200
        end if
        
        ! Damage regime
        state = 1
        do iter = 1,self%itemax
            phi = Fphi(self,be)
            equ  = phi-quad
            if (abs(equ).le.cvequ) exit
            db_equ = Db_Fphi(self,be)
            be = utnewt(be,equ,db_equ,iter,mem,xmin=be,xmax=1.d0)
        end do
        if (iter.gt.self%itemax) then
            self%exception = 1
            goto 999
        end if        
        

200     continue

    end if


    ! Stress computation (even if not resi)
    stiff = FB(self,be)
    sig   = stiff*sigpos + signeg
        

    
    if (self%rigi) then

        ! Contribution elastique a endommagement fixe
        dsde = stiff*deps_sigpos + deps_signeg
        
        ! Contribution liee a la variation d'endommagement
        if ( (.not. self%elas) .and. (state.eq.1) ) then
            db_B      = db_FB(self,be)
            db_phi    = db_Fphi(self,be)
            deps_quad = DerivateQuad(crit)
            dsde      = dsde + db_B/db_phi * proten(sigpos,deps_quad)
        end if
        
    end if
    
999 continue
end subroutine ComputeDamage



! =====================================================================
!  PATH FOLLOWING
! =====================================================================

subroutine PathFollowing(self,targetDamage,eps0,eps1,etamin,etamax,cvb, &
                nsol, sol, sgn)

    implicit none
    type(CONSTITUTIVE_LAW), intent(inout):: self
    real(kind=8),intent(in) :: targetDamage, eps0(:), eps1(:), etamin, etamax, cvb
    integer,intent(out)     :: nsol,sgn(2)
    real(kind=8),intent(out):: sol(2)
! ---------------------------------------------------------------------
! targetDamage  damage to be reached
! eps0          constant strain
! eps1          path-following strain
! etamin        lower bound for eta
! etamax        upper bound for eta
! cvb           expected accuracy with respect to the damage b
! nsol          number of solutions eta (-1, 0, 1 or 2)
!                   if -1 -> point does not contribute to path-following
! sol           solutions eta
! sgn           for each solution, -1 if decreasing function, +1 otherwise
! ---------------------------------------------------------------------
    aster_logical         :: empty, croiss, gauche, droite
    integer               :: n
    real(kind=8)          :: lcst,cvequ,cvquad,etam,etap,etal
    real(kind=8)          :: gm,dgm,gp,dgp,gl,dgl
    type(CRITERION)       :: crit
    real(kind=8),parameter:: red = 1.d-2
! ---------------------------------------------------------------------

    !  Non controlable point (two close to the bound)
    if (targetDamage .ge. 0.99) then
        nsol = -1
        goto 999
    end if

    ! Constant term
    lcst = - Fphi(self,targetDamage)

    ! Convergence thresholds
    cvequ  = Db_Fphi(self,targetDamage) * cvb
    cvquad = red*cvequ

    ! Criterion Functor    
    crit = CritInit(self%ndimsi,self%mat%cmat,self%itemax,cvquad)
    call SetPathFollowing(crit,eps0,eps1,lcst)
    
    ! Refined bounds
    call BoundsCstPathFollowing(crit, etamin, etamax, empty, etam, etap)    

    ! No solution
    if (empty) then
        nsol = 0
        goto 999
    endif


    ! Solution of the scalar equation
    
    call ComputePathFollowing(crit,etam, gm, dgm)
    if (crit%exception .ne. 0) then
        self%exception = 1
        goto 999
    end if
    
    call ComputePathFollowing(crit,etap, gp, dgp)
    if (crit%exception .ne. 0) then
        self%exception = 1
        goto 999
    end if


    ! 1. ne contribue pas au pilotage (toujours sous le seuil)

    if (gm .le. 0 .and. gp .le. 0) then
        nsol = -1
        goto 999
    end if


    ! 2. bornes superieures au seuil : double newton

    if (gm .ge. 0 .and. gp .ge. 0) then

        do n = 1, self%itemax

!           test de convergence
            gauche = abs(gm).le.cvequ
            droite = abs(gp).le.cvequ
            if (gauche .and. droite) goto 150

!           absence de solution si fonction au-dessus de zero
            if (dgm .ge. 0 .or. dgp .le. 0) then
                nsol = 0
                goto 999
            endif

!           methode de newton a gauche et a droite
            if (.not.gauche) etam = etam - gm/dgm
            if (.not.droite) etap = etap - gp/dgp

!           absence de solution si fonction au-dessus de zero
            if (etap.lt.etam) then
                nsol = 0
                goto 999
            end if

!           calcul de la fonction et derivee
            if (.not.gauche) then
                call ComputePathFollowing(crit,etam, gm, dgm)
                if (crit%exception .ne. 0) then
                    self%exception = 1
                    goto 999
                end if
            end if
            
            if (.not.droite) then
                call ComputePathFollowing(crit,etap, gp, dgp)
                if (crit%exception .ne. 0) then
                    self%exception = 1
                    goto 999
                end if
            end if
            
        end do

        ! echec de la resolution avec le nombre d'iterations requis
        self%exception = 1
        goto 999

        ! Storage
150     continue

        nsol   = 2
        sol(1) = etam
        sgn(1) = -1
        sol(2) = etap
        sgn(2) =  1
        goto 999
    endif


    ! 3. bornes de part et d'autre du seuil --> newton depuis positive
    if (gm .ge. 0) then
        croiss = .false.
        etal = etam
        gl = gm
        dgl = dgm
    else
        croiss = .true.
        etal = etap
        gl = gp
        dgl = dgp
    endif

    do n = 1, self%itemax

!       TEST DE CONVERGENCE
        if (abs(gl) .le. cvequ) goto 250
!
!       METHODE DE NEWTON A GAUCHE ET A DROITE
        etal = etal - gl/dgl
        call ComputePathFollowing(crit, etal, gl, dgl)
        if (crit%exception .ne. 0) then
            self%exception = 1
            goto 999
        end if
    end do
    self%exception = 1

    ! Storage
250 continue
    nsol = 1
    sol(1) = etal
    sgn(1) = merge(1, -1, croiss)


999 continue
    end subroutine PathFollowing



! =====================================================================
!  POST-TREATMENTS
! =====================================================================

function PostTreatment(self, eps, deps, be, postm) result(post)

    implicit none
    type(CONSTITUTIVE_LAW), intent(in)  :: self
    real(kind=8),           intent(in)  :: eps(:)
    real(kind=8),           intent(in)  :: deps(:)
    real(kind=8),           intent(in)  :: be
    type(POST_TREATMENT),   intent(in)  :: postm
    type(POST_TREATMENT)                :: post
! ---------------------------------------------------------------------
! eps   strain at the end of the time-step
! deps  strain increment
! be    damage at the end of the time-step
! postm post-treatment variables at the beginning of the time-step
! ---------------------------------------------------------------------
    real(kind=8):: wpos, wneg, wpos12, wneg12
! ---------------------------------------------------------------------
    
    ! stiffness damage
    post%damsti = 1-FB(self,be)
    
    ! elastic energy
    call ComputeEnergy(self%mat%unil,eps,wpos,wneg)
    post%welas = wneg + (1-post%damsti)*wpos
    
    ! dissipated energy
    call ComputeEnergy(self%mat%unil,eps - 0.5d0*deps, wpos12, wneg12)
    post%wdiss = postm%wdiss + (post%damsti - postm%damsti)*wpos12

end function PostTreatment


! =====================================================================
!  Intermediate function h(b)
! =====================================================================

function Fh(self,b) result(res)
    
    implicit none
    type(CONSTITUTIVE_LAW), intent(in):: self
    real(kind=8):: res
    real(kind=8):: b
! ---------------------------------------------------------------------
    real(kind=8):: c1,cr
! ---------------------------------------------------------------------
    
    c1  = 0.5d0*self%mat%kappa*self%mat%m0 - 1
    cr  = 0.5d0*self%mat%kappa*(self%mat%d1-self%mat%m0)
    res = 1 + c1*b + cr*b**self%mat%r

end function Fh



function Db_Fh(self,b) result(res)
    
    implicit none
    type(CONSTITUTIVE_LAW), intent(in):: self
    real(kind=8):: res
    real(kind=8):: b
! ---------------------------------------------------------------------
    real(kind=8):: c1,cr
! ---------------------------------------------------------------------
    
    c1  = 0.5d0*self%mat%kappa*self%mat%m0 - 1
    cr  = 0.5d0*self%mat%kappa*(self%mat%d1-self%mat%m0)
    res = c1 + cr*self%mat%r * b**(self%mat%r-1)
    
end function Db_Fh



! =====================================================================
!  Stiffness function FB(b)
! =====================================================================

function FB(self,b) result(res)
    
    implicit none
    type(CONSTITUTIVE_LAW), intent(in):: self
    real(kind=8):: res
    real(kind=8):: b
! ---------------------------------------------------------------------

    res = (1-b) / Fh(self,b)

end function FB



function Db_FB(self,b) result(res)
    
    implicit none
    type(CONSTITUTIVE_LAW), intent(in):: self
    real(kind=8):: res
    real(kind=8):: b
! ---------------------------------------------------------------------
    real(kind=8):: h,db_h
! ---------------------------------------------------------------------
    
    h    = Fh(self,b)
    db_h = Db_Fh(self,b)
    res  = - (h + (1-b)*db_h) / h**2
    
end function Db_FB



! =====================================================================
!  Threshold function Phi(b)
! =====================================================================

function Fphi(self,b) result(res)
    
    implicit none
    type(CONSTITUTIVE_LAW), intent(in):: self
    real(kind=8):: res
    real(kind=8):: b
! ---------------------------------------------------------------------
    res = Fh(self,b)**2

end function Fphi


function Db_Fphi(self,b) result(res)
    
    implicit none
    type(CONSTITUTIVE_LAW), intent(in):: self
    real(kind=8):: res
    real(kind=8):: b
! ---------------------------------------------------------------------
    res = 2 * Db_Fh(self,b) * Fh(self,b)

end function Db_Fphi

    

end module endo_loca_module
