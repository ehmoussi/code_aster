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

module vmis_isot_nl_module

    use scalar_newton_module,       only: &
            newton_state, &
            utnewt
    
    use  tenseur_dime_module,       only: &
            proten, &
            kron, &
            voigt, &
            identity


    implicit none
    private
    public:: CONSTITUTIVE_LAW, Init, InitGradVari, InitViscoPlasticity, Integrate




#include "asterf_types.h"
#include "asterc/r8gaem.h"
#include "asterc/r8nnem.h"
#include "asterfort/assert.h"
#include "asterfort/rcvalb.h"
#include "asterfort/utmess.h"
#include "asterc/r8pi.h"
#include "asterc/r8prem.h"

! --------------------------------------------------------------------------------------------------

    ! Material characteristics

    type MATERIAL
        real(kind=8) :: lambda,deuxmu,troismu,troisk
        real(kind=8) :: r0,rh,r1,g1,r2,g2,rk,p0,gk
        real(kind=8) :: c  = 0.d0
        real(kind=8) :: r  = 0.d0
        real(kind=8) :: v0 = 0.d0
        real(kind=8) :: q  = 2.d0
    end type MATERIAL

    
    ! VMIS_ISOT_NL class
    type CONSTITUTIVE_LAW
        integer       :: exception = 0
        aster_logical :: elas,rigi,resi,vari,pred
        aster_logical :: grvi = ASTER_FALSE
        aster_logical :: visc = ASTER_FALSE
        integer       :: ndimsi,itemax
        real(kind=8)  :: cvuser
        real(kind=8)  :: phi = 0.d0
        real(kind=8)  :: telq 
        real(kind=8)  :: kam  
        type(MATERIAL):: mat
    end type CONSTITUTIVE_LAW

    
    
    
contains


! =====================================================================
!  OBJECT CREATION AND INITIALISATION
! =====================================================================

function Init(ndimsi, option, fami, kpg, ksp, imate, itemax, precvg) &
    result(self)
        
    implicit none
    
    integer,intent(in)          :: kpg, ksp, imate, itemax, ndimsi
    real(kind=8), intent(in)    :: precvg
    character(len=16),intent(in):: option
    character(len=*),intent(in) :: fami
    type(CONSTITUTIVE_LAW)      :: self
! --------------------------------------------------------------------------------------------------
! ndimsi    symmetric tensor dimension (2*ndim)
! option    computation option
! fami      Gauss point set
! kpg       Gauss point number
! ksp       Layer number (for structure elements)
! imate     material pointer
! itemax    max number of iterations for the solver
! precvg    required accuracy (with respect to stress level))
! --------------------------------------------------------------------------------------------------
    integer,parameter   :: nbel=2, nbec=9
! --------------------------------------------------------------------------------------------------
    integer             :: iok(nbel+nbec)
    real(kind=8)        :: valel(nbel), valec(nbec)
    real(kind=8)        :: r8nan
    character(len=16)   :: nomel(nbel), nomec(nbec)
! --------------------------------------------------------------------------------------------------
    data nomel /'E','NU'/
    data nomec /'R0','RH','R1','GAMMA_1','R2','GAMMA_2','RK','P0','GAMMA_M'/
! --------------------------------------------------------------------------------------------------

    ! Variables non initialisees            
    r8nan     = r8nnem()
    self%telq = r8nan
    self%kam  = r8nan


    ! Parametres generaux
    self%ndimsi = ndimsi
    self%itemax = itemax
    self%cvuser = precvg

    
    ! Options de calcul
    self%elas   = option.eq.'RIGI_MECA_ELAS' .or. option.eq.'FULL_MECA_ELAS'
    self%rigi   = option.eq.'RIGI_MECA_TANG' .or. option.eq.'RIGI_MECA_ELAS' &
             .or. option.eq.'FULL_MECA' .or. option.eq.'FULL_MECA_ELAS'
    self%resi   = option.eq.'FULL_MECA_ELAS' .or. option.eq.'FULL_MECA'      &
             .or. option.eq.'RAPH_MECA'
    self%vari   = option.eq.'FULL_MECA_ELAS' .or. option.eq.'FULL_MECA'      &
             .or. option.eq.'RAPH_MECA'
    self%pred   = option.eq.'RIGI_MECA_ELAS' .or. option.eq.'RIGI_MECA_TANG'
    
    ASSERT (self%rigi .or. self%resi)
    
    
    ! Elasticity material parameters
    call rcvalb(fami,kpg,ksp,'+',imate,' ','ELAS',0,' ',[0.d0],nbel,nomel,valel,iok,2)
    self%mat%lambda  = valel(1)*valel(2)/((1+valel(2))*(1-2*valel(2)))
    self%mat%deuxmu  = valel(1)/(1+valel(2))
    self%mat%troismu = 1.5d0*self%mat%deuxmu
    self%mat%troisk  = valel(1)/(1.d0-2.d0*valel(2))


    ! Hardening material parameters
    call rcvalb(fami,kpg,ksp,'+',imate,' ','ECRO_NL',0,' ',[0.d0],nbec,nomec,valec,iok,2)
    self%mat%r0 = valec(1)
    self%mat%rh = valec(2)
    self%mat%r1 = valec(3)
    self%mat%g1 = valec(4)
    self%mat%r2 = valec(5)
    self%mat%g2 = valec(6)
    self%mat%rk = valec(7)
    self%mat%p0 = valec(8)
    self%mat%gk = valec(9)
    
end function Init


! =====================================================================
!  COMPLEMENTARY INITIALISATION FOR GRAD_VARI
! =====================================================================

subroutine InitGradVari(self,fami,kpg,ksp,imate,lag,apg) 
        
    implicit none
    
    integer,intent(in)          :: kpg, ksp, imate
    real(kind=8),intent(in)     :: lag,apg
    character(len=*),intent(in) :: fami
    type(CONSTITUTIVE_LAW),intent(inout)      :: self
! --------------------------------------------------------------------------------------------------
! fami      Gauss point set
! kpg       Gauss point number
! ksp       Layer number (for structure elements)
! imate     material pointer
! lag       Lagrangian value
! apg       nonlocal hardening variable
! --------------------------------------------------------------------------------------------------
    integer,parameter:: nb=2
! --------------------------------------------------------------------------------------------------
    integer             :: iok(nb)
    real(kind=8)        :: vale(nb)
    character(len=16)   :: nom(nb)
! --------------------------------------------------------------------------------------------------
    data nom /'C_GRAD_VARI','PENA_LAGR'/
! --------------------------------------------------------------------------------------------------

    self%grvi = ASTER_TRUE

    call rcvalb(fami,kpg,ksp,'+',imate,' ','NON_LOCAL',0,' ',[0.d0],nb,nom,vale,iok,2)
    self%mat%c = vale(1)
    self%mat%r = vale(2)
    self%phi   = lag + self%mat%r*apg
            
end subroutine InitGradVari



! =====================================================================
!  COMPLEMENTARY INITIALISATION FOR VISCOPLASTICITY
! =====================================================================

subroutine InitViscoPlasticity(self,fami,kpg,ksp,imate,deltat) 
        
    implicit none
    
    integer,intent(in)                  :: kpg, ksp, imate
    real(kind=8),intent(in)             :: deltat
    character(len=*),intent(in)         :: fami
    type(CONSTITUTIVE_LAW),intent(inout):: self
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

    self%visc = ASTER_TRUE

    call rcvalb(fami,kpg,ksp,'+',imate,' ','NORTON',0,' ',[0.d0],nb,nom,vale,iok,2)
    self%mat%q  = 1.d0/vale(1)
    self%mat%v0 = vale(2)/deltat**self%mat%q
            
end subroutine InitViscoPlasticity



! =====================================================================
!  INTEGRATION OF THE CONSTITUTIVE LAW (MAIN ROUTINE)
! =====================================================================


subroutine Integrate(self, eps, vim, sig, vip, deps_sig, dphi_sig, deps_vi, dphi_vi) 

    implicit none

    type(CONSTITUTIVE_LAW), intent(inout):: self
    real(kind=8), intent(in)         :: eps(:), vim(:)
    real(kind=8),intent(out)         :: sig(:), vip(:), deps_sig(:,:)
    real(kind=8),intent(out),optional:: dphi_sig(:),deps_vi(:),dphi_vi
! --------------------------------------------------------------------------------------------------
! eps       strain at the end of the time step
! vim       internal variables at the beginning of the time step
! sig       stress at the end of the time step
! vip       internal variables at the end of the time step
! deps_sig  derivee dsig / deps
! dphi_sig  derivee dsig / dphi   (grad_vari)
! deps_vi   derivee dka  / deps  (grad_vari)
! dphi_vi   derivee dka  / dphi  (grad_vari)
! --------------------------------------------------------------------------------------------------
    integer         :: state
    real(kind=8)    :: ka,ep(self%ndimsi),rac2(self%ndimsi)
    real(kind=8)    :: vdum1(self%ndimsi), vdum2(self%ndimsi), rdum
! --------------------------------------------------------------------------------------------------

    ASSERT (present(dphi_sig) .eqv. self%grvi)
    ASSERT (present(deps_vi)  .eqv. self%grvi)
    ASSERT (present(dphi_sig) .eqv. self%grvi)

    
! unpack internal variables
    rac2  = voigt(self%ndimsi)
    ka    = vim(1)
    state = nint(vim(2))
    ep    = vim(3:2+self%ndimsi)*rac2


! damage behaviour integration
    if (self%grvi) then
        call ComputePlasticity(self, eps, ka, state, ep, sig, deps_sig, dphi_sig, deps_vi, dphi_vi)
    else
        call ComputePlasticity(self, eps, ka, state, ep, sig, deps_sig, vdum1, vdum2, rdum)
    end if
    if (self%exception .ne. 0) goto 999


! pack internal variables 
    if (self%vari) then
        vip(1) = ka
        vip(2) = state
        vip(3:2+self%ndimsi) = ep/rac2
    end if


999 continue    
end subroutine Integrate



! =====================================================================
!  PLASTICITY COMPUTATION AND TANGENT OPERATORS
! =====================================================================

subroutine ComputePlasticity(self, eps, ka, state, ep, &
                  t, deps_t, dphi_t,deps_ka,dphi_ka) 

    implicit none

    type(CONSTITUTIVE_LAW),intent(inout):: self
    real(kind=8),intent(in)             :: eps(:)
    real(kind=8),intent(inout)          :: ep(:),ka
    integer,intent(inout)               :: state
    real(kind=8),intent(out)            :: t(:),deps_t(:,:)
    real(kind=8),intent(out)            :: dphi_t(:),deps_ka(:),dphi_ka
! --------------------------------------------------------------------------------------------------
! eps       deformation a la fin du pas de temps
! ka        variable d'ecrouissage kappa (in=debut pas de temps, out=fin)
! state     etat pendant le pas (0=elastique, 1=plastique, 2=singulier) (in=debut, out=fin)
! ep        deformation plastique (in=debut, out=fin)
! t         contrainte en fin de pas de temps
! deps_t    derivee dt / deps
! dphi_t    derivee dt / dphi   (grad_vari)
! deps_ka   derivee dka / deps  (grad_vari)
! dphi_ka   derivee dka / dphi  (grad_vari)
! --------------------------------------------------------------------------------------------------
    aster_logical   :: visc
    integer         :: ite,itev
    real(kind=8)    :: kr(size(eps)),presig
    real(kind=8)    :: kam,kae,mve,kas,rks,rvs,mvs
    real(kind=8)    :: tel(size(eps)),telh,telq,teld(size(eps)),dep(size(eps))
    real(kind=8)    :: pdev(size(eps),size(eps))
    real(kind=8)    :: equ,dka_equ,dv_equ,rk,rv,kax,res,rvx,mh
    real(kind=8)    :: n(size(eps)),deps_telq(size(eps)),deps_n(size(eps),size(eps))
    real(kind=8)    :: dtelq_ka,dka_mv
    type(newton_state):: mem
! --------------------------------------------------------------------------------------------------

!   Initialisation
    kr      = kron(self%ndimsi)
    kam     = ka

!   Contrainte elastique
    tel  = self%mat%lambda*sum(eps(1:3)-ep(1:3))*kr + self%mat%deuxmu*(eps-ep)
    telh = sum(tel(1:3)) / 3.d0
    teld = tel - telh*kr
    telq = sqrt(1.5d0 * dot_product(teld,teld))

!   Copie des informations dans self pour utilisation des fonctions du module
    self%kam  = kam
    self%telq = telq

!   Bornes pour kappa et valeurs correspondantes pour la fonction MV
    kae = kam
    kas = kam + telq/self%mat%troismu
    mve = f_m_hat(self,kae)
    rks = f_ecro(self,kas) 
    rvs = f_visco(self,kas)
    mvs = -(rks+rvs)

!   Seuil de convergence absolu
    presig = (f_ecro(self,0.d0)+self%phi)*self%cvuser


! ======================================================================
!               INTEGRATION DE LA LOI DE COMPORTEMENT
! ======================================================================

    if (.not. self%resi) goto 800


! --------------------------------------------------------------------------------------------------
!  REGIME ELASTIQUE
! --------------------------------------------------------------------------------------------------

!   Tir elastique
    if (mve .le. presig) then
        state = 0
        t     = tel
        goto 800
    end if



! --------------------------------------------------------------------------------------------------
!  REGIME ECOULEMENT SINGULIER
! --------------------------------------------------------------------------------------------------

    if (mvs .le. 0) goto 200
    
    ka   = kas
    kax  = kas - (rks+rvs)/(self%mat%r+self%mat%rh)
    visc = ASTER_FALSE
    
    do ite = 1,self%itemax

        ! Evaluation du terme plastique et du terme visqueux
        rk  = f_ecro(self,ka) 
        rv  = f_visco(self,ka)
        
        ! Test de convergence
        res = rk + rv
        if (abs(res) .le. presig) exit
        
        ! Borne max discriminante plas / visc identifiee
        if (res.gt.0 .and. rk.le.presig) then
            visc = ASTER_TRUE
            rvx  = rv
            itev = ite-1
        end if
        
        ! Resolution de la plasticite seule (sans viscosite)
        if (.not. visc) then    
            equ     = rk
            dka_equ = dka_ecro(self,ka) 
            ka      = utnewt(ka,equ,dka_equ,ite,mem,xmin=kas,xmax=kax)
         
        ! Resolution de la viscoplasticite (avec changement de variable)
        else
            equ    = rk + rv
            dv_equ = dka_ecro(self,ka)*dv_inv_visco(self,rv) + 1
            rv     = utnewt(rv,equ,dv_equ,ite-itev,mem,xmin=rvs,xmax=rvx)
            ka     = inv_visco(self,rv)
        end if
        
    end do
    if (ite.gt.self%itemax) then
        self%exception = 1
        goto 999
    end if
    
    state = 2
    ep    = ep  + teld/self%mat%deuxmu
    t     = telh*kr
    goto 800
    
    
    
! --------------------------------------------------------------------------------------------------
!  REGIME ECOULEMENT REGULIER
! --------------------------------------------------------------------------------------------------

200 continue 
    ka   = kae
    visc = ASTER_FALSE
    
    do ite = 1,self%itemax
    
        ! Evaluation du terme plastique et du terme visqueux
        mh  = f_m_hat(self,ka) 
        rv  = f_visco(self,ka)
            
        ! Test de convergence
        res = -mh + rv
        if (abs(res) .le. presig) exit

        ! Borne max discriminante plas / visc identifiee
        if (res.gt.0 .and. -mh.le.presig) then
            visc = ASTER_TRUE
            rvx  = rv
            itev = ite-1
        end if

        ! Resolution de la plasticite seule (sans viscosite)
        if (.not. visc) then    
            equ     = -mh
            dka_equ = -dka_m_hat(self,ka) 
            ka      = utnewt(ka,equ,dka_equ,ite,mem,xmin=kae,xmax=kas)
         
        ! Resolution de la viscoplasticite (avec changement de variable)
        else
            equ    = -mh + rv
            dv_equ = -dka_m_hat(self,ka)*dv_inv_visco(self,rv) + 1
            rv     = utnewt(rv,equ,dv_equ,ite-itev,mem,xmin=0.d0,xmax=rvx)
            ka     = inv_visco(self,rv)
        end if
   
    end do
    if (ite.gt.self%itemax) then
        self%exception = 1
        goto 999
    end if  

    state = 1
    dep   = 1.5d0*(ka-kam)*teld/telq
    ep    = ep + dep
    t     = telh*kr + teld - self%mat%deuxmu*dep




! ======================================================================
!                           MATRICES TANGENTES
! ======================================================================

800 continue

    if (.not. self%rigi) goto 999

    dphi_t  = 0
    deps_ka = 0
    dphi_ka = 0

    ! Etat pour choisir l'operateur tangent en phase de prediction
    if (self%pred) then
        
        ! En regime de frontiere, le choix de la matrice est guide par le pas precedent
        ! Sinon, on evalue par rapport a mve et mvs
        if (abs(mve).gt.presig .and. abs(mvs).gt.presig) then
            if (mve.le.0) then
                state = 0
            else if (mvs.ge.0) then
                state = 2
            else
                state = 1
            end if
        end if
        
    end if
    
        
    ! Regime elastique 
    if (state.eq.0 .or. self%elas) then
        deps_t = self%mat%lambda*proten(kr,kr) + self%mat%deuxmu*identity(self%ndimsi)


    ! Regime plastique regulier 
    else if (state .eq. 1) then

        ! Projecteur deviatorique
        pdev = identity(self%ndimsi) - proten(kr,kr)/3.d0
        
        ! Quantites liees a la contrainte elastique 
        n         = teld/telq
        deps_telq = self%mat%troismu*n
        deps_n    = (self%mat%deuxmu*pdev - proten(n,deps_telq))/telq
                
        ! Variations de kappa
        dka_mv   = dka_m_hat(self,ka) - dka_visco(self,ka)
        dtelq_ka = - dtelq_m_hat(self,ka)/dka_mv
        deps_ka  = dtelq_ka*deps_telq
        dphi_ka  = - dphi_m_hat(self,ka)/dka_mv
        
        ! Operateurs tangents
        deps_t = self%mat%lambda*proten(kr,kr) + self%mat%deuxmu*identity(self%ndimsi) &
               - self%mat%troismu*(ka-kam)*deps_n &
               - self%mat%troismu*proten(n,deps_ka)

        dphi_t  = -self%mat%troismu*n*dphi_ka


    ! Regime singulier (dphi_t et deps_ka sont nulles)
    else if (state.eq.2) then
        deps_t  = self%mat%troisk/3.d0 * proten(kr,kr)      
        dphi_ka = - dphi_ecro(self,ka) / (dka_ecro(self,ka)+dka_visco(self,ka))

    else
        ASSERT(ASTER_FALSE)
    end if


999 continue

    end subroutine ComputePlasticity

! ----------------------------------------------------------------------------------------
!  Liste des fonctions intermediaires et leurs derivees
! ----------------------------------------------------------------------------------------


! --> Derivees: dka_*, dteh_*, dteq_*, dphi_*

function f_visco(self,ka) result(res)
    implicit none
    type(CONSTITUTIVE_LAW), intent(in):: self
    real(kind=8):: res
    real(kind=8),intent(in)::ka
    res = self%mat%v0 * (ka-self%kam)**self%mat%q
end function f_visco


function dka_visco(self,ka) result(res)
    implicit none
    type(CONSTITUTIVE_LAW), intent(in):: self
    real(kind=8):: res
    real(kind=8),intent(in)::ka
    
    if (self%visc .and. self%pred) then
        ! infini -> on renvoie une valeur tres grande
        ! (ok car utilise uniquement pour l'operateur tangent)
        res = r8gaem()      
    else
        res = self%mat%v0 * self%mat%q * (ka-self%kam)**(self%mat%q-1)
    end if
    
end function dka_visco


function inv_visco(self,v) result(res)
    implicit none
    type(CONSTITUTIVE_LAW), intent(in):: self
    real(kind=8):: res
    real(kind=8),intent(in)::v
    res = self%kam + (v/self%mat%v0)**(1/self%mat%q)
end function inv_visco


function dv_inv_visco(self,v) result(res)
    implicit none
    type(CONSTITUTIVE_LAW), intent(in):: self
    real(kind=8):: res
    real(kind=8),intent(in)::v
    res = 1/(self%mat%q *self%mat%v0) * (v/self%mat%v0)**(1/self%mat%q-1)
end function dv_inv_visco


function f_ecro(self,ka) result(res)
    implicit none
    type(CONSTITUTIVE_LAW), intent(in):: self
    real(kind=8):: res
    real(kind=8),intent(in)::ka
    res = self%mat%r0 + self%mat%rh*ka + &
          self%mat%r1*(1-exp(-self%mat%g1*ka)) + &
          self%mat%r2*(1-exp(-self%mat%g2*ka)) + &
          self%mat%rk*(ka+self%mat%p0)**self%mat%gk + &
          self%mat%r*ka - self%phi
end function f_ecro


function dka_ecro(self,ka) result(res)
    implicit none
    type(CONSTITUTIVE_LAW), intent(in):: self
    real(kind=8):: res
    real(kind=8),intent(in)::ka
    
    res = self%mat%rh + &
          self%mat%r1*self%mat%g1*exp(-self%mat%g1*ka) + &
          self%mat%r2*self%mat%g2*exp(-self%mat%g2*ka) + &
          self%mat%rk*self%mat%gk*(ka+self%mat%p0)**(self%mat%gk-1) + &
          self%mat%r
    
end function dka_ecro


function dphi_ecro(self,ka) result(res)
    implicit none
    type(CONSTITUTIVE_LAW), intent(in):: self
    real(kind=8):: res
    real(kind=8),intent(in)::ka
    res = -1.d0
end function dphi_ecro


function f_m_hat(self,ka) result(res)
    implicit none
    type(CONSTITUTIVE_LAW), intent(in):: self
    real(kind=8):: res
    real(kind=8),intent(in)::ka
    res = self%telq - self%mat%troismu*(ka-self%kam)-f_ecro(self,ka)   
end function f_m_hat


function dka_m_hat(self,ka) result(res)
    implicit none
    type(CONSTITUTIVE_LAW), intent(in):: self
    real(kind=8):: res
    real(kind=8),intent(in)::ka
    res = - self%mat%troismu - dka_ecro(self,ka)  
end function dka_m_hat


function dtelq_m_hat(self,ka) result(res)
    implicit none
    type(CONSTITUTIVE_LAW), intent(in):: self
    real(kind=8):: res
    real(kind=8),intent(in)::ka
    res = 1.d0
end function dtelq_m_hat


function dphi_m_hat(self,ka) result(res)
    implicit none
    type(CONSTITUTIVE_LAW), intent(in):: self
    real(kind=8):: res
    real(kind=8),intent(in)::ka
    res = - dphi_ecro(self,ka)
end function dphi_m_hat



end module vmis_isot_nl_module
