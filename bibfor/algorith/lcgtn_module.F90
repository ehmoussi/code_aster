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

module lcgtn_module

    use scalar_newton_module,       only: &
            newton_state, &
            utnewt
    
    use  tenseur_dime_module,       only: &
            proten, &
            kron, &
            voigt, &
            identity
            
    use visc_norton_module,         only: &
            VISCO, &
            ViscoInit => Init, &
            f_dka, &
            dkv_dka, &
            f_vsc, &
            dkv_vsc, &
            ddka_vsc, &
            solve_slope_dka
             
    implicit none
    private
    public:: CONSTITUTIVE_LAW, Init, InitGradVari, InitViscoPlasticity, Integrate


#include "asterf_types.h"
#include "asterc/r8nnem.h"
#include "asterc/r8pi.h"
#include "asterc/r8prem.h"
#include "asterfort/assert.h"
#include "asterfort/lcgrad.h"
#include "asterfort/rcvalb.h"
#include "asterfort/utmess.h"



    ! Material characteristics (without viscosity)
    type MATERIAL
        real(kind=8) :: lambda,deuxmu,troismu,troisk,young
        real(kind=8) :: r0,rh,r1,g1,r2,g2,rk,p0,gk
        real(kind=8) :: q1,q2,f0,fc,fr
        real(kind=8) :: fn,pn,sn,c0,kf,ki,epc,b0
        real(kind=8) :: c  = 0.d0
        real(kind=8) :: r  = 0.d0
    end type MATERIAL



    ! GTN class
    type CONSTITUTIVE_LAW
        integer       :: exception = 0
        aster_logical :: elas,rigi,vari,pred
        aster_logical :: grvi = ASTER_FALSE
        integer       :: ndimsi,itemax
        real(kind=8)  :: cvuser
        real(kind=8)  :: phi = 0.d0
        real(kind=8)  :: telh 
        real(kind=8)  :: telq 
        real(kind=8)  :: q1f 
        real(kind=8)  :: jac 
        real(kind=8)  :: kam  
        real(kind=8)  :: visc_dka = 0.d0
        real(kind=8)  :: visc_ts  = 0.d0
        real(kind=8)  :: visc_vsc = 0.d0
        type(MATERIAL):: mat
        type(VISCO)   :: visco
    end type CONSTITUTIVE_LAW

       
    logical:: DBG = .FALSE.
    
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
    integer,parameter   :: nbel=2, nbec=9, nben=13
! --------------------------------------------------------------------------------------------------
    integer             :: iok(nbel+nbec+nben)
    real(kind=8)        :: valel(nbel), valec(nbec),valen(nben)
    real(kind=8)        :: r8nan
    character(len=16)   :: nomel(nbel), nomec(nbec), nomen(nben)
! --------------------------------------------------------------------------------------------------
    data nomel /'E','NU'/
    data nomec /'R0','RH','R1','GAMMA_1','R2','GAMMA_2','RK','P0','GAMMA_M'/
    data nomen /'Q1','Q2','PORO_INIT','COAL_PORO','COAL_ACCE', &
                'NUCL_GAUSS_PORO','NUCL_GAUSS_PLAS','NUCL_GAUSS_DEV', &
                'NUCL_CRAN_PORO','NUCL_CRAN_INIT','NUCL_CRAN_FIN', &
                'NUCL_EPSI_PENTE','NUCL_EPSI_INIT'/
! --------------------------------------------------------------------------------------------------

    ! Variables non initialisees            
    r8nan     = r8nnem()
    self%telh = r8nan
    self%telq = r8nan
    self%q1f  = r8nan
    self%jac  = r8nan
    self%kam  = r8nan


    ! Parametres generaux
    self%ndimsi = ndimsi
    self%itemax = itemax
    self%cvuser = precvg

    
    ! Options de calcul
    self%elas   = option.eq.'RIGI_MECA_ELAS' .or. option.eq.'FULL_MECA_ELAS'
    self%rigi   = option.eq.'RIGI_MECA_TANG' .or. option.eq.'RIGI_MECA_ELAS' &
             .or. option.eq.'FULL_MECA' .or. option.eq.'FULL_MECA_ELAS'
!    self%resi   = option.eq.'FULL_MECA_ELAS' .or. option.eq.'FULL_MECA'      &
!             .or. option.eq.'RAPH_MECA'
    self%vari   = option.eq.'FULL_MECA_ELAS' .or. option.eq.'FULL_MECA'      &
             .or. option.eq.'RAPH_MECA'
    self%pred   = option.eq.'RIGI_MECA_ELAS' .or. option.eq.'RIGI_MECA_TANG'
    
!    ASSERT (self%rigi .or. self%resi)
    
    
    ! Elasticity material parameters
    call rcvalb(fami,kpg,ksp,'+',imate,' ','ELAS',0,' ',[0.d0],nbel,nomel,valel,iok,2)
    self%mat%young   = valel(1)
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


    !  Damage parameters
    call rcvalb(fami,kpg,ksp,'+',imate,' ','GTN', 0,' ',[0.d0],nben,nomen,valen,iok,2)
    self%mat%q1 = valen(1)
    self%mat%q2 = valen(2)
    self%mat%f0 = valen(3)
    self%mat%fc = valen(4)
    self%mat%fr = self%mat%fc + (1.d0/self%mat%q1-self%mat%fc)/valen(5)
    self%mat%fn = valen(6)
    self%mat%pn = valen(7)
    self%mat%sn = valen(8)
    self%mat%c0 = valen(9)
    self%mat%ki = valen(10)
    self%mat%kf = valen(11)
    self%mat%b0 = valen(12)
    self%mat%epc= valen(13)

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

subroutine InitViscoPlasticity(self,visc,fami,kpg,ksp,imate,deltat) 
        
    implicit none
    aster_logical,intent(in)            :: visc
    integer,intent(in)                  :: kpg, ksp, imate
    real(kind=8),intent(in)             :: deltat
    character(len=*),intent(in)         :: fami
    type(CONSTITUTIVE_LAW),intent(inout):: self
! --------------------------------------------------------------------------------------------------
! visc      True if viscosity is present
! fami      Gauss point set
! kpg       Gauss point number
! ksp       Layer number (for structure elements)
! imate     material pointer
! deltat    time increment (instap - instam)
! --------------------------------------------------------------------------------------------------

    self%visco = ViscoInit(visc,fami,kpg,ksp,imate,deltat)

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
! sig       stress at the end of the time step (resi) or the beginning of the time step (not resi)
! vip       internal variables at the end of the time step
! deps_sig  derivee dsig / deps
! dphi_sig  derivee dsig / dphi   (grad_vari)
! deps_vi   derivee dka  / deps  (grad_vari)
! dphi_vi   derivee dka  / dphi  (grad_vari)
! --------------------------------------------------------------------------------------------------
    integer         :: state
    real(kind=8)    :: ka,f,ep(self%ndimsi),rac2(self%ndimsi)
    real(kind=8)    :: vdum1(self%ndimsi), vdum2(self%ndimsi), rdum
    real(kind=8)    :: epcum,fnuc,poro_log
! --------------------------------------------------------------------------------------------------

    if (DBG) write(6,*) 'START Integrate'
    
    ASSERT (present(dphi_sig) .eqv. self%grvi)
    ASSERT (present(deps_vi)  .eqv. self%grvi)
    ASSERT (present(dphi_sig) .eqv. self%grvi)

    
! unpack internal variables
    rac2  = voigt(self%ndimsi)
    ka    = vim(1)
    f     = max(self%mat%f0,vim(2))
    state = nint(vim(3))
    ep    = vim(4:3+self%ndimsi)*rac2
    epcum = vim(10)
    fnuc  = vim(11)


! Plasticity behaviour integration
    if (self%grvi) then
        call ComputePlasticity(self, eps, ka, f, state, ep, epcum, fnuc, sig, deps_sig, dphi_sig, &
                               deps_vi, dphi_vi)
    else
        call ComputePlasticity(self, eps, ka, f, state, ep, epcum, fnuc, sig, deps_sig, &
                               vdum1, vdum2, rdum)
    end if
    if (self%exception .ne. 0) goto 999


! Post-treatment
    poro_log = log(f)-log(self%mat%f0)
    

! pack internal variables 
    if (self%vari) then
        vip(1) = ka
        vip(2) = f
        vip(3) = state
        vip(8:9) = 0
        vip(4:3+self%ndimsi) = ep/rac2
        vip(10) = epcum
        vip(11) = fnuc
        vip(12) = poro_log
    end if


999 continue    
    if (DBG) write(6,*) 'END Integrate'
end subroutine Integrate




! =====================================================================
!  PLASTICITY AND DAMAGE COMPUTATION 
! =====================================================================


subroutine ComputePlasticity(self, eps, ka, f, state, ep, &
                  epcum, fnuc, t, deps_t, dphi_t,deps_ka,dphi_ka) 

    implicit none

    type(CONSTITUTIVE_LAW),intent(inout):: self
    real(kind=8),intent(in)             :: eps(:)
    real(kind=8),intent(inout)          :: ep(:),ka, f, epcum, fnuc
    integer,intent(inout)               :: state
    real(kind=8),intent(out)            :: t(:),deps_t(:,:)
    real(kind=8),intent(out)            :: dphi_t(:),deps_ka(:),dphi_ka
! --------------------------------------------------------------------------------------------------
! eps       deformation a la fin du pas de temps
! ka        variable d'ecrouissage kappa (in=debut pas de temps, out=fin)
! f         porosity (in=t-, out=t+)
! state     etat pendant le pas (0=elastique, 1=plastique, 2=singulier) (in=debut, out=fin)
! ep        deformation plastique (in=debut, out=fin)
! epcum     cumulated plastic strain
! fnuc      nucleation porosity
! t         contrainte en fin de pas de temps (resi) ou au debut du pas de temps (not resi)
! deps_t    derivee dt / deps
! dphi_t    derivee dt / dphi   (grad_vari)
! deps_ka   derivee dka / deps  (grad_vari)
! dphi_ka   derivee dka / dphi  (grad_vari)
! --------------------------------------------------------------------------------------------------
    integer     :: iteint,iteext,i,typmin,typmax,flow_type
    real(kind=8):: kr(size(eps)),cvsigm,cv_fine,cveps,cv_g,cvcass,jac,q1f,kam
    real(kind=8):: tel(size(eps)),telh,telq,teld(size(eps)),tels,epm(size(eps)),deph,depd(size(eps))
    real(kind=8):: gamm1,desh,desq,pin,chim1,cs
    real(kind=8):: dka_r0,kv,kvmin,kvmax
    real(kind=8):: dkas,dkaz,dkamin,dkamax,dkaini,dka,coef
    real(kind=8):: tsm, tss, tshmin, tshmax
    real(kind=8):: kml1, kml2, lbd, lbd1, lbd2
    real(kind=8):: equint,equext,d_equint,d_equext,p,q,ts
    real(kind=8):: p1,p2,fg1,fg2,fgmax,sgn,dts_p,dkv_ts,dka_ts
    real(kind=8):: lambda_bar,deuxmu_bar
    real(kind=8):: mat(2,2),vec(2)
    real(kind=8):: djac_p,dteh_p,dteq_p,dphi_p,deps_p(size(eps))
    real(kind=8):: deps_jac(size(eps)),deps_teh(size(eps)),deps_teq(size(eps))
    real(kind=8):: dp_q,dts_q,djac_q,dteh_q,dteq_q,dphi_q,deps_q(size(eps))
    real(kind=8):: djac_ts,dteh_ts,dteq_ts,dphi_ts
    real(kind=8):: djac_ka,dteh_ka,dteq_ka
    type(newton_state):: memint,memext
! ----------------------------------------------------------------------

    if (DBG) write(6,*) 'START Compute_Plasticity'

! --------------------------------------------------------------------------------------------------
!   Initialisation
! --------------------------------------------------------------------------------------------------

    kr      = kron(self%ndimsi)
    kam     = ka
    epm     = ep
    dka     = 0.d0
    jac     = exp(sum(eps(1:3)))
    cvsigm  = min(jac,1.d0)*f_ecro(self,0.d0)*self%cvuser
    cv_fine = 1.d-1 * cvsigm
    cveps   = cv_fine/self%mat%young
    cvcass  = sqrt(self%cvuser)


!   Calcul de la porosite effective (coalescence)
    if (f.le.self%mat%fc) then
        q1f = self%mat%q1 * f 
    else
        q1f = self%mat%q1*self%mat%fc + (1-self%mat%q1*self%mat%fc) &
                /(self%mat%fr-self%mat%fc)*(f-self%mat%fc)
    end if
    ASSERT(q1f.gt.0 .and. q1f.le.1)
    if (DBG) write (6,*) 'q1f = ',q1f

    ! Cas d'un point casse -> fin de l'integration
    if ((1-q1f) .le. cvcass) then
        call Broken_Point(self, eps, ka, f, state, ep, &
                  epcum, fnuc, t, deps_t, dphi_t,deps_ka,dphi_ka)
        goto 999
    end if

!   Precision sur la fonction G
    cv_g = (1-q1f)*self%cvuser
    
!   Contrainte elastique
    tel  = self%mat%lambda*sum(eps(1:3)-ep(1:3))*kr + self%mat%deuxmu*(eps-ep)
    telh = sum(tel(1:3)) / 3.d0
    teld = tel - telh*kr
    telq = sqrt(1.5d0 * dot_product(teld,teld))


!   Perturbation en cvsigm*1e-3 pour eviter la singularite TELH=0
    telh    = sign(max(cvsigm*1.d-3, abs(telh)) , telh)


!   Copie des informations dans self pour utilisation des fonctions du module
    self%kam  = kam
    self%telh = telh
    self%telq = telq
    self%q1f  = q1f
    self%jac  = jac


    ! Frontieres des regimes elastique et singulier
    gamm1 = (1-q1f)**2 / (2*q1f)
    desh  = telh/self%mat%troisk
    desq  = telq/self%mat%deuxmu
    if (desh**2 + desq**2 .eq. 0) then
        pin = 0
    else
        chim1 = (self%mat%q2*desq)**2 / (9*desh**2/q1f + (self%mat%q2*desq)**2)
        cs    = 2*gamm1*(1-chim1)/(1+sqrt(1+2*gamm1*chim1*(1-chim1)))
        pin   = 2/self%mat%q2*acosh(1+cs)*abs(desh) + 2.d0/3.d0*(1-q1f)*sqrt(1-cs/gamm1)*desq
    end if
    dkas = jac*pin
    tsm  = f_ts_hat(self,dka=0.d0)
    tss  = f_ts_hat(self,dka=dkas)
    
    
    ! Valeurs de transition entre viscosite dominante et viscosite faible
    if (self%visco%visc) then
        dka_r0        = dka_ecro(self,0.d0)
        self%visc_dka = solve_slope_dka(self%visco,dka_r0)
        self%visc_vsc = f_vsc(self%visco,dka=self%visc_dka)
        self%visc_ts  = f_ts_hat(self,dka=self%visc_dka)
    end if
    
    

    if (DBG) write(6,*) 'INTEGRATION'
    if (DBG) write(6,*) 'rigi = ',self%rigi
    
    
    
! --------------------------------------------------------------------------------------------------
!               INTEGRATION DE LA LOI DE COMPORTEMENT
! --------------------------------------------------------------------------------------------------


! ----------------------------------------------------------------------
!  REGIME ELASTIQUE
! ----------------------------------------------------------------------

    ! Elasticite (avec marge) si tels < T(kam) + cvsigm
    if (is_tels_less_than(self,tsm+cvsigm)) then
        state = 0
        t     = tel
        goto 500
    end if


    
! ----------------------------------------------------------------------
!  REGIME PLASTIQUE SINGULIER
! ----------------------------------------------------------------------
   
    ! Cas singulier standard (tss < 0) ou si T* petit (tels<cvsigm)
    if (tss.le.cvsigm .or. is_tels_less_than(self,cvsigm)) then

        ! Calcul de dkaz tq T_hat(dkaz) = 0
        if (abs(tss).le.cvsigm) then
            dkaz = dkas
        else
            dkamin = merge(dkas,0.d0,tss.lt.0)
            call Solve_ts_hat(self,0.d0,cvsigm,dkamin,dkaz)
            if (self%exception .eq. 1) goto 999
        end if

        ! Mise a jour de la plasticite et des contraintes
        dka = dkaz
        ka  = kam + dka
        ep  = eps
        t   = 0
        state = 2
        goto 500
    end if



! ----------------------------------------------------------------------
!  REGIME PLASTIQUE REGULIER
! ----------------------------------------------------------------------

    ! 1. Calcul d'une borne min dkamin = max(0.d0 , dkaz) avec tolerance
    
    if (tsm.ge.cv_fine) then
        dkamin = 0.d0
        typmin = 1
        tshmin = tsm
    else
        call Solve_ts_hat(self,2*cv_fine,cv_fine,0.d0,dkaz)        
        if (self%exception .eq. 1) goto 999
        dkamin = dkaz
        typmin = 2
        tshmin = f_ts_hat(self,dka=dkamin)        
    end if


    ! Test si la borne min conduit a une solution facile
    ! precision numerique pour garantir dkamin < lbd 
    if (typmin .eq. 2) then
        p = Solve_g_hat(self,tshmin,cv_g,0.d0)
        if (self%exception .eq. 1) goto 999
        lbd = f_lbd_hat(self,p,tshmin)
        if (lbd.le.dkamin) then
            p     = 0.d0
            q     = 0.d0
            ts    = 0.d0
            dka   = dkamin
            state = 2
            goto 400
        end if
    end if

    ! 2. Calcul d'une borne max dkamax = min(dkas, dkael) ou T_hat(dkael)=tels
    
    tels = Compute_Star(self,1.d0,1.d0,cv_fine)
    if (self%exception .eq. 1) goto 999

    if (.not. is_tels_less_than(self,tss+cv_fine)) then
        dkamax = dkas
        typmax = 1
        tshmax = tss
    else
        call Solve_ts_hat(self,tels-1.5d0*cv_fine, 0.5d0*cv_fine,0.d0,dkamax)
        if (self%exception .eq. 1) goto 999
        typmax = 2
        tshmax = f_ts_hat(self,dka=dkamax) 
    end if
    
    ASSERT(dkamin .lt. dkamax)
    ASSERT(tshmin .le. tshmax)
    ASSERT(tshmin .le. tels)
    ASSERT(tshmin .gt. 0)
    ASSERT(.not. is_tels_less_than(self,tshmax))


    ! Test si la borne max conduit a une solution facile
    ! precision numerique pour garantir lbd < dkamax 
    if (typmax .eq. 2) then
        p = Solve_g_hat(self,tshmax,cv_g,0.d0)
        lbd = f_lbd_hat(self,p,tshmax)
        if (lbd.ge.dkamax) then
            p     = 1.d0
            q     = 1.d0
            ts    = tels
            dka   = dkamax
            state = 0
            goto 400
        end if
    end if
    
    

    ! 3. Estimation initiale par resolution du probleme de von Mises

    call Solve_Mises(self,cv_fine,dkaz,flow_type,dkaini)
    if (self%exception .eq. 1) goto 999

    ! Si Mises ne fournit pas une initialisation pertinente 
    !   -> initialisation par une methode de corde
    if (flow_type.eq.0 .or. flow_type.eq.2 .or. &
        (flow_type.eq.1 .and. (dkaini.le.dkamin .or. dkaini.ge.dkamax))) then
        if (DBG) write(6,*) 'tels     =',tels
        coef = (tels-tshmin)/(tels-tshmin+tshmax)
        dkaini = dkamin + coef*(dkamax-dkamin)
    end if  
    
    ASSERT(dkaini.ge.dkamin .and. dkaini.le.dkamax)
    if (DBG) write(6,*) 'flow_type=',flow_type
    if (DBG) write(6,*) 'kam      = ',kam
    if (DBG) write(6,*) 'dkaini   =',dkaini
    if (DBG) write(6,*) 'dkamin   =',dkamin,'  tshmin = ',tshmin
    if (DBG) write(6,*) 'dkamax   =',dkamax,'  tshmax = ',tshmax
    
        

    ! 4. Preparation du changement de variable en presence de viscoplasticite

    ! La solution est-elle dans le domaine ou la viscoplasticite est dominante
    if (self%visco%visc) then
        if (self%visc_dka .le. dkamin) then
            self%visco%active = ASTER_FALSE
        else if (self%visc_dka .ge. dkamax) then
            self%visco%active = ASTER_TRUE
        else
            p = Solve_g_hat(self,self%visc_ts,cv_g,0.d0)
            self%visco%active = f_lbd_hat(self,p,self%visc_ts) .lt. self%visc_dka
        end if
    else
        self%visco%active = ASTER_FALSE
    end if
    
    
    ! Correction des bornes si viscoplasticite dominante ou non
    if (self%visco%visc) then
        if (self%visco%active) then
            kvmin = f_vsc(self%visco,dka=dkamin)
            kvmax = min(self%visc_vsc, f_vsc(self%visco,dka=dkamax))
            kv    = min(self%visc_vsc, f_vsc(self%visco,dka=dkaini))
        else
            kvmin = max(self%visc_dka,dkamin)
            kvmax = dkamax
            kv    = max(self%visc_dka,dkaini)
        end if  
    else
        kvmin = dkamin
        kvmax = dkamax
        kv    = dkaini
    end if
    ASSERT (kvmin.le.kv .and. kv.le.kvmax)
    
    
    
    ! 5. Resolution du systeme non lineaire de deux equations
    ! Resolution par rapport a kv de : kml := dka - lbd(p,Ts) == 0
    
    do iteext = 1,self%itemax
    

        ! 3.1 Calcul de Ts(ka)
        if (DBG) write(6,*) '3.1'
        dka = f_dka(self%visco,kv)
        ts = f_ts_hat(self,kv=kv)
        if (DBG) write(6,*) 'kv = ',kv,'  dka = ',dka,'  ts = ',ts
        
        
        ! 3.2 Resolution de G_hat(p,ts) == -prec/2 par rapport a p 
        !     --> borne min de l'encadrement de la solution exacte
        !     (Rappel: G croissant par rapport a p)
        p1 = Solve_g_hat(self,ts,0.5d0*cv_g,-0.5d0*cv_g)
        if (self%exception .eq. 1) goto 999
        fg1  = f_g_hat(self,p1,ts)
        lbd1 = f_lbd_hat(self,p1,ts)
        kml1 = dka - lbd1
        if (DBG) write (6,*) 'p1=',p1,'  lbd1=',lbd1,' kml1=',kml1,'  fg1=',fg1
        
        ! Test si convergence de la boucle exterieure
        if (abs(ts - f_ts_hat(self,dka=lbd1)) .le. cvsigm) then
            if (DBG) write(6,*) 'CVG-1.SIGM'
            p   = p1
            dka = lbd1
            exit        
        end if
        if (abs(dka-lbd1) .le. cveps) then
            if (DBG) write(6,*) 'CVG-1.EPSI'
            p   = p1
            exit        
        end if


        ! 3.3 Resolution de G_hat(p,ts)=prec/2
        !     --> borne max de l'encadrement de la solution exacte
        if (DBG) write(6,*) '3.3'

        ! Test de la borne p=1
        fgmax = f_g_hat(self,1.d0,ts)
        ASSERT(fgmax.ge.0.d0)
        if ((fgmax).le.cv_g) then
            p2 = 1.d0
            fg2 = fgmax
        else
            p2 = Solve_g_hat(self,ts,0.5d0*cv_g,0.5d0*cv_g,p_ini=p1)
            if (self%exception .eq. 1) goto 999
            fg2 = f_g_hat(self,p2,ts)
        end if
        lbd2 = f_lbd_hat(self,p2,ts)
        kml2 = dka - lbd2
        if (DBG) write (6,*) 'p2=',p2,'  lbd2=',lbd2,'=',f_lbd_hat(self,p2,ts),' kml2=',kml2, &
                            '  fg2=',fg2,'=',f_g_hat(self,p2,ts)
      

        ! Test de convergence de la boucle exterieure sur la seconde borne
        if (abs(ts - f_ts_hat(self,dka=lbd2)).le.cvsigm) then
            if (DBG) write(6,*) 'CVG-2.SIGM'
            p   = p2
            dka = lbd2
            exit        
        end if
        if (abs(dka-lbd2) .le. cveps) then
            if (DBG) write(6,*) 'CVG-2.EPSI'
            p   = p2
            exit        
        end if


        ! Valeur de p optimale -> celle qui conduit au meilleur lambda
        ASSERT(fg1*fg2 .le. 0)
        ASSERT(p2.gt.p1)
        p = merge(p1,p2,abs(dka-lbd1).le.abs(dka-lbd2))


        ! 3.4 Si l'intervalle (p1,p2) permet de trouver une solution KML(p,ts,ka)==0 
        !   -> recherche de p
        if (DBG) write(6,*) '3.4'
        if (kml1*kml2.lt.0) then
            if (DBG) write (6,*) '3.4 -> GO'
            if (DBG) write (6,*) 'dka = ',dka,'  ts = ',ts
            if (DBG) write (6,*) 'lbd1 = ',lbd1,' = ',f_lbd_hat(self,p1,ts)
            if (DBG) write (6,*) 'lbd2 = ',lbd2,' = ',f_lbd_hat(self,p2,ts)
            if (DBG) write (6,*) 'p1=',p1,' kml1=',kml1,'=',dka-lbd1,'  fg1=',&
                                    fg1,'=',f_g_hat(self,p1,ts)
            if (DBG) write (6,*) 'p2=',p2,' kml2=',kml2,'=',dka-lbd2,'  fg2=',&
                                    fg2,'=',f_g_hat(self,p2,ts)
            
            ! croissance ou decroissance de KML(p,ts,ka) par rapport a p dans l'intervalle (p1,p2)
            sgn = sign(1.d0,kml2-kml1)

            ! resolution dans l'intervalle
            if (DBG) write (6,*) 'utnewt 3B'
            do iteint = 1,self%itemax
                lbd      = f_lbd_hat(self,p,ts)
                equint   = sgn*(dka-lbd)
                d_equint = -sgn * dp_lbd_hat(self,p,ts)
                if (DBG) write (6,*) 'ite = ',iteint,'  p = ',p,'  lbd = ',lbd,'  equ = ',&
                                        equint,'  d_equ = ',d_equint
                if (DBG) write (6,*) 'cvg = ',ts-f_ts_hat(self,dka=lbd)
                if (abs(ts-f_ts_hat(self,dka=lbd)).le.cvsigm) then
                    dka = lbd
                    exit
                end if
                if (abs(dka-lbd) .le. cveps) exit
                p = utnewt(p,equint,d_equint,iteint,memint,xmin=p1,xmax=p2)
            end do
            if (DBG) write (6,*) 'utnewt 3E'
            if (iteint.gt.self%itemax) then
                self%exception = 1
                goto 999
            end if   
            exit
        end if
        

        ! 3.5 Sinon KML(p,ts,ka) <> 0 dans l'intervalle (p1,p2) -> nouvel itere pour dka
        equext = dka - f_lbd_hat(self,p,ts)
        
        dts_p  = -dts_g_hat(self,p,ts)/dp_g_hat(self,p,ts)
        dkv_ts = dkv_ts_hat(self,kv)
        d_equext = dkv_dka(self%visco,kv) - (dp_lbd_hat(self,p,ts)*dts_p &
                    + dts_lbd_hat(self,p,ts))*dkv_ts
        if (DBG) write (6,*) 'iteext=',iteext,'  kv=',kv,'  equext=',equext,'  d_equext=',d_equext
        if (DBG) write (6,*) 'dka=',dka,'  lambda=',f_lbd_hat(self,p,ts),'  p=',p,'  ts=',ts
        if (DBG) write (6,*) 'utnewt 4B'
!        kv = utnewt(kv,equext,d_equext,iteext,memext,xmin=kvmin,xmax=kvmax,usemin=ASTER_FALSE)
        kv = utnewt(kv,equext,d_equext,iteext,memext,xmin=kvmin,xmax=kvmax)
        if (DBG) write (6,*) 'utnewt 4E'

    end do
    if (iteext.gt.self%itemax) then
        self%exception = 1
        goto 999
    end if        

    q = f_q_hat(self,p,ts)
    state = 1


400 continue
    if (DBG) write(6,*) '6.1'
    ka    = kam + dka
    deph  = (1-p)*telh/self%mat%troisk
    depd  = (1-q)*teld/self%mat%deuxmu
    ep    = ep + deph*kr + depd
    t     = p*telh*kr + q*teld


    
! ----------------------------------------------------------------------
!   Actualisation de la porosite (sans impact sur les matrices tangentes car q1f inchange)   
! ----------------------------------------------------------------------

500 continue
    if (self%vari .and. (state.eq.1 .or. state.eq.2)) then
        call Update_porosity(self,epm,ep,ka,epcum,f,fnuc)      
    end if



! ======================================================================
!                           MATRICES TANGENTES
! ======================================================================

    if (.not.self%rigi) goto 999

    if (DBG) write (6,*) 'MATRICE TANGENTE'
    deps_t  = 0
    dphi_t  = 0
    deps_ka = 0
    dphi_ka = 0


!    if (self%pred) then
!        p  = 1.d0
!        q  = 1.d0
!        ts = tsm
!        t  = tel
!    end if


!    ! Etat pour choisir l'operateur tangent en phase de prediction
!    if (self%pred) then
        
!        ! En regime de frontiere, le choix de la matrice est guide par le pas precedent
!        ! Sinon, on evalue par rapport a mve et mvs
        
!        if (is_tels_less_than(self,tsm-cvsigm)) then
!            state = 0
!        else if (is_tels_less_than(self,cvsigm) .or. tss.le.-cvsigm) then
!            state = 2
!        else if (.not. is_tels_less_than(self,tsm+cvsigm) .and. tss.gt.cvsigm) then
!            state = 1
!        end if
        
!    end if
    
    ! Correction eventuelle pour choisir l'operateur tangent en phase de prediction
    ! Si elastique mais presque plastique -> plastique
    
    if (self%pred .and. state.eq.0 .and. .not. self%elas) then
        
        if (.not. is_tels_less_than(self,tsm-cvsigm)) then
            state = 1
            p  = 1.d0
            q  = 1.d0
            ts = tsm
            t  = tel
        end if
        
    end if


    ! Regime elastique (seul deps_t est non nulle, egale a la matrice d'elasticite)
    if (state.eq.0 .or. self%elas) then
        deps_t(1:3,1:3) = self%mat%lambda
        do i = 1,size(eps)
            deps_t(i,i) = deps_t(i,i) + self%mat%deuxmu
        end do


    ! Regime plastique regulier
    else if (state.eq.1) then
        
        ! Variations des inconnues principales (p,ka)
        mat(1,1) =  dts_m_hat(self,p,ts,dka)
        mat(1,2) = -dts_g_hat(self,p,ts)
        mat(2,1) = -dp_m_hat(self,p,ts,dka)
        mat(2,2) =  dp_g_hat(self,p,ts)
        mat      = mat / (mat(1,1)*mat(2,2)-mat(1,2)*mat(2,1))

        vec = -matmul(mat,[dteh_g_hat(self,p,ts),dteh_m_hat(self,p,ts,dka)])
        dteh_p  = vec(1)
        dteh_ts = vec(2)
        
        vec = -matmul(mat,[dteq_g_hat(self,p,ts),dteq_m_hat(self,p,ts,dka)])
        dteq_p  = vec(1)
        dteq_ts = vec(2)
        
        vec = -matmul(mat,[0.d0,djac_m_hat(self,p,ts,dka)])
        djac_p  = vec(1)
        djac_ts = vec(2)
        
        vec = -matmul(mat,[0.d0,dphi_m_hat(self,p,ts,dka)])
        dphi_p  = vec(1)
        dphi_ts = vec(2)
        
        ! Variations de q
        dp_q   = dp_q_hat(self,p,ts)
        dts_q  = dts_q_hat(self,p,ts)
        dteh_q = dp_q*dteh_p + dts_q*dteh_ts + dteh_q_hat(self,p,ts)
        dteq_q = dp_q*dteq_p + dts_q*dteq_ts
        djac_q = dp_q*djac_p + dts_q*djac_ts
        dphi_q = dp_q*dphi_p + dts_q*dphi_ts

        ! Variations de ka
        dka_ts = dka_ts_hat(self,dka)
        dteh_ka = (dteh_ts                       ) / dka_ts
        dteq_ka = (dteq_ts                       ) / dka_ts
        djac_ka = (djac_ts - djac_ts_hat(self,dka)) / dka_ts
        dphi_ka = (dphi_ts - dphi_ts_hat(self,dka)) / dka_ts

 
        ! Variations des invariants par rapport a epsilon
        deps_teh = self%mat%troisk/3.d0 * kr
        deps_teq = self%mat%troismu*teld/telq
        deps_jac = jac*kr

        ! dt/deps
        lambda_bar = (p*self%mat%troisk - q*self%mat%deuxmu)/3.d0
        deuxmu_bar = q*self%mat%deuxmu
        deps_t(1:3,1:3) = lambda_bar
        do i = 1,size(eps)
            deps_t(i,i) = deps_t(i,i) + deuxmu_bar
        end do
        deps_p = djac_p*deps_jac + dteh_p*deps_teh + dteq_p*deps_teq
        deps_q = djac_q*deps_jac + dteh_q*deps_teh + dteq_q*deps_teq
        deps_t = deps_t + proten(telh*kr,deps_p) + proten(teld,deps_q)

        ! dka/deps
        deps_ka = djac_ka*deps_jac + dteh_ka*deps_teh + dteq_ka*deps_teq
        
        ! dt/dphi
        dphi_t = dphi_p*telh*kr + dphi_q*teld

        ! dka/dphi -> deja calcule ci-dessus
        
        
    ! Regime singulier (deps_t et dphi_t sont nulles)
    else if (state.eq.2) then
        deps_jac = jac*kr
        dka_ts  = dka_ts_hat(self,dka)
        dphi_ka = - dphi_ts_hat(self,dka)/dka_ts
        djac_ka = - djac_ts_hat(self,dka)/dka_ts
        deps_ka = djac_ka*deps_jac


    else
        ASSERT(.false.)
    end if




!    Fin de la routine
999  continue

    if (DBG) write (6,*) 'Code retour = ',self%exception
    ASSERT(.not. DBG .or. self%exception .eq. 0)
    if (DBG) write(6,*) 'END Compute_Plasticity'
end subroutine ComputePlasticity




! =====================================================================
!  Is Tel_star less than a value ? 
! =====================================================================

aster_logical function is_tels_less_than(self,thre) 

    implicit none

    type(CONSTITUTIVE_LAW),intent(inout):: self
    real(kind=8),intent(in)::thre
! --------------------------------------------------------------------------------------------------
! thre      threshold: return True if tels < thre
! --------------------------------------------------------------------------------------------------

    if (DBG) write(6,*) 'BEGIN is_tels_less_than'
    is_tels_less_than = ASTER_FALSE
    
    ! Precaution pour le calcul numerique de G
    if (thre.le.0) goto 100
    if (self%telq.gt.thre*sqrt(1+self%q1f**2)) goto 100
    if (1.5d0*self%mat%q2*self%telh .gt. thre*acosh((1+self%q1f**2)/(2*self%q1f))) goto 100

!   On exploite le caractere decroissant de G et le fait que G(Tel, Tels) = 0
    is_tels_less_than =  to_aster_logical( f_g(self,1.d0,1.d0,thre) .lt. 0 )

100 continue
    if (DBG) write(6,*) 'END is_tels_less_than'
end function is_tels_less_than




! =====================================================================
!  Solve f_ts_hat(dka) = ts with dka > 0
! =====================================================================

subroutine Solve_ts_hat(self,ts_target,cv_ts,dkamin,dka)

    implicit none

    type(CONSTITUTIVE_LAW),intent(inout):: self
    real(kind=8),intent(in)  ::ts_target, cv_ts, dkamin
    real(kind=8),intent(out) ::dka
! --------------------------------------------------------------------------------------------------
! ts_target     target equivalent stress
! cv_ts         expected accuracy on the residual
! exi_ka        True if a positive solution exist, else False
! dka           solution hardening variable
! --------------------------------------------------------------------------------------------------
    aster_logical:: buffer
    integer     :: ite
    real(kind=8):: ts_min, equ, d_equ, kv,kvmin
    type(newton_state):: mem
! --------------------------------------------------------------------------------------------------
    if (DBG) write(6,*) 'BEGIN Solve_ts_hat'
    buffer = self%visco%active
    
    ! Lower bound
    ts_min = f_ts_hat(self,dka=dkamin)
    if ( abs(ts_min - ts_target) .le. cv_ts) then
        dka    = dkamin
        goto 999
    end if

    ! Existence
    ASSERT (ts_min - ts_target .le. 0) 
    
    ! Zone de viscosite dominante (chgt de variable) ou non
    if (.not. self%visco%visc) then
        self%visco%active = ASTER_FALSE
        kv    = dkamin
    else if (self%visc_ts .le. ts_target) then
        self%visco%active = ASTER_FALSE
        kv = max(dkamin,self%visc_dka)
    else
        self%visco%active = ASTER_TRUE
        kv = max(0.d0,f_vsc(self%visco,dka=dkamin))
    end if
    kvmin = kv
    
    ! Newton method
    do ite = 1,self%itemax
        equ   = f_ts_hat(self,kv=kv) - ts_target
        d_equ = dkv_ts_hat(self,kv)
        if (abs(equ).le.cv_ts) exit
        if (DBG) write (6,*) 'utnewt 5B'
!        write (6,*) ite,ka,equ,d_equ
        kv = utnewt(kv,equ,d_equ,ite,mem,xmin=kvmin)
        if (DBG) write (6,*) 'utnewt 5E'
    end do
    if (ite.gt.self%itemax) then
        self%exception = 1
        goto 999
    end if
    dka = f_dka(self%visco,kv)
    
999 continue
    self%visco%active = buffer
    if (DBG) write(6,*) 'END Solve_ts_hat'
end subroutine Solve_ts_hat




! =====================================================================
!  Solve f_g_hat(p,ts) = g0 with respect to p
! =====================================================================

function Solve_g_hat(self,ts,cvg,g0,p_ini) result(p)

    implicit none

    type(CONSTITUTIVE_LAW),intent(inout):: self
    real(kind=8),intent(in)  ::ts,g0,cvg
    real(kind=8),intent(in),optional::p_ini
    real(kind=8) ::p
! --------------------------------------------------------------------------------------------------
! ts     equivalent stress
! g0     right hand side term
! cvg    accuracy
! --------------------------------------------------------------------------------------------------
    integer     :: ite
    real(kind=8):: equ, d_equ, pmin
    type(newton_state):: mem
! --------------------------------------------------------------------------------------------------
    if (DBG) write(6,*) 'BEGIN Solve_g_hat'
    pmin = bnd_pmin(self,ts,g0)
    ASSERT(pmin.lt.1.d0)
    if (DBG) write(6,*) 'pmin = ',pmin,'gmin-g0=',f_g_hat(self,pmin,ts)-g0
    
    ! Point initial
    if (present(p_ini)) then
        p = max(p_ini,pmin)
    else
        p   = 1.d0
    end if
    
    if (DBG) write (6,*) 'utnewt 1B'
    do ite = 1,self%itemax
        equ   = f_g_hat(self,p,ts)-g0
        d_equ = dp_g_hat(self,p,ts)
        if (abs(equ).le.cvg) exit
        if (DBG) write(6,*) p,equ,d_equ,ite
        p = utnewt(p,equ,d_equ,ite,mem,xmin=pmin,xmax=1.d0)
    end do
    if (DBG) write (6,*) 'utnewt 1E'
    if (ite.gt.self%itemax) then
        self%exception = 1
        goto 999
    end if     
999 continue
    if (DBG) write(6,*) 'END Solve_g_hat'
end function Solve_g_hat



! --------------------------------------------------------------------------------------------------
! Minimal bound pmin for equation G_hat(p,ts) = g0
! --------------------------------------------------------------------------------------------------

function bnd_pmin(self,ts,g0) result(pmin)
    implicit none
    type(CONSTITUTIVE_LAW),intent(inout):: self
    real(kind=8),intent(in)::ts,g0
    real(kind=8)::pmin
! --------------------------------------------------------------------------------------------------
    real(kind=8):: re,al,a,l0,b,c0,fmin,p0,dmin,coef,sh
! --------------------------------------------------------------------------------------------------

    ! G(0,ts)-g0 < 0
    ASSERT(g0.ge.-(1-self%q1f)**2)

    ! Initialisation
    re  = abs(self%telh/ts)
    al  = self%mat%troismu / self%mat%troisk
    a   = al*re
    l0  = 0.5d0*self%mat%q2*self%q1f
    b   = 1.5d0*self%mat%q2*re
    c0  = (4*al)/(3*self%mat%q2**2*self%q1f)
    
    ! Denominateur minimal
    if (c0.le.1) then
        fmin = 0.d0
    else if ( c0.ge.cosh(b)) then
        fmin = l0*sinh(b)-a
    else
        p0 = acosh(c0)/b
        fmin = l0*sinh(b*p0)-a*p0
    end if
    dmin = a + fmin
        
    coef = ((0.5d0*self%telq*self%mat%q2*self%q1f)/(ts*dmin))**2 + self%q1f
    sh   = sqrt((g0+(1-self%q1f)**2)/coef)
    pmin = asinh(sh)/b

end function bnd_pmin




! =====================================================================
!  Solve von Mises problem (with plastic flow)
! =====================================================================

subroutine Solve_Mises(self,cv_ts,dkaz,flow_type,dka)

    implicit none

    type(CONSTITUTIVE_LAW),intent(inout):: self
    real(kind=8),intent(in)  :: cv_ts,dkaz
    integer,intent(out)      :: flow_type
    real(kind=8),intent(out) :: dka
! --------------------------------------------------------------------------------------------------
! cv_ts         precision souhaitee sur T(ka) + c0 + c1*ka = 0
! dkaz          plastic increment such as T(dkaz)=0
! flow_type     0 = elastic, 1 = regular flow, 2 = singular flow
! dka           solution: increment of the hardening variable 
! --------------------------------------------------------------------------------------------------
    aster_logical:: buffer
    integer     :: ite
    real(kind=8):: dkasvm, equ, d_equ, c0, c1, tsm, kv, kvmin, kvmax
    type(newton_state):: mem
! --------------------------------------------------------------------------------------------------
    if (DBG) write(6,*) 'BEGIN Solve_Mises'

    ! Initialisation
    buffer = self%visco%active 
    
    
    ! Elastic solution
    tsm = f_ts_hat(self,dka=0.d0)
    if (self%telq/(1-self%q1f) .le. tsm + cv_ts) then
        dka = 0.d0
        flow_type = 0
        goto 999
    end if
    
    
    ! Coefficient du terme affine 
    c1 = self%mat%troismu/self%jac/(1-self%q1f)**2
    c0 = - self%telq/(1-self%q1f) 
    
    
    ! Valeur de transition regulier / singulier pour von Mises
    dkasvm = -c0/c1


    ! Regime singulier pour von Mises (GTN regulier)
    if (f_ts_hat(self,dka=dkasvm) .le. -cv_ts) then
        flow_type = 2
        dka = dkaz
        goto 999
    end if
    

    ! Regime d'ecoulement regulier
    flow_type = 1
    
    ! Viscosite active (chgt de variable) ou non
    if (self%visco%visc .and. (self%visc_ts+c0+c1*self%visc_dka).gt.0) then
        self%visco%active = ASTER_TRUE
        kv    = 0.d0
        kvmin = 0.d0
        kvmax = min(self%visc_vsc, f_vsc(self%visco,dka=dkasvm))
    else if (self%visco%visc) then
        self%visco%active = ASTER_FALSE
        kv    = self%visc_dka
        kvmin = self%visc_dka
        kvmax = dkasvm
    else
        self%visco%active = ASTER_FALSE
        kv    = -(tsm+c0)/c1
        kvmin = 0.d0
        kvmax = dkasvm  
    end if
    ASSERT(kvmin.le.kv .and. kv.le.kvmax)
    
    
    do ite = 1,self%itemax
        dka   = f_dka(self%visco,kv)
        equ   = f_ts_hat(self,kv=kv) + c0 + c1*dka
        if (abs(equ).le.cv_ts) exit
        d_equ = dkv_ts_hat(self,kv) + c1*dkv_dka(self%visco,kv)
        if (DBG) write (6,*) 'utnewt 6B'
        kv = utnewt(kv,equ,d_equ,ite,mem,xmin=kvmin,xmax=kvmax)
        if (DBG) write (6,*) 'utnewt 6E'
    end do
    if (ite.gt.self%itemax) then
        self%exception = 1
        goto 999
    end if

999 continue
    self%visco%active = buffer
    if (DBG) write(6,*) 'END Solve_Mises'
end subroutine Solve_Mises




! =====================================================================
!  Compute the GTN equivalent norm of a stress tensor (by lower values)
! =====================================================================

function Compute_Star(self,p,q,cv_ts) result(ts)

    implicit none

    type(CONSTITUTIVE_LAW),intent(inout):: self
    real(kind=8),intent(in):: cv_ts, p, q
    real(kind=8)  ::ts
! --------------------------------------------------------------------------------------------------
! p             normalised hydrostatic stress TH = p*TelH
! q             normalised von Mises stress   TQ = q*TelQ
! cv_ts         expected accuracy on the residual
! return ts     T_star
! --------------------------------------------------------------------------------------------------
! Methode:
! On cherche la racine x --> G(p,q,1/x) fonction croissante, convexe et non bornee
! On assure in fine G(p,q,ts) > 0 et G(p,q,ts+cv_ts) < 0
! --------------------------------------------------------------------------------------------------
    integer     :: ite
    real(kind=8):: ts1, ts2, x, equ, d_equ, ofsm, ofsp
    type(newton_state):: mem
! --------------------------------------------------------------------------------------------------
    if (DBG) write(6,*) 'BEGIN Compute_Star'

    ! Cas d'un tenseur nul
    if (p.eq.0.d0 .and. q.eq.0.d0) then
        ts = 0.d0
        goto 999
    end if
    
    ! Borne max et point de depart de la methode de Newton
    ts1 = sqrt((q*self%telq)**2 + self%q1f*(1.5d0*self%mat%q2*p*self%telh)**2)/(1-self%q1f)
    ts2 = 1.5d0*self%mat%q2*abs(p*self%telh)/acosh(1+0.5d0*(1-self%q1f)**2/self%q1f)
    x   = 1.d0 / max(ts1,ts2)

    if (DBG) write (6,*) 'telh=',self%telh,'  telq=',self%telq
    if (DBG) write (6,*) 'ts1: ',ts1, f_g(self,p,q,ts1)
    if (DBG) write (6,*) 'ts1: ',ts1, f_g(self,p,q,ts1)
    if (DBG) write (6,*) 'ts2: ',ts2, f_g(self,p,q,ts2)
    if (DBG) write (6,*) 'x  : ',x
    
    ! Resolution G(p,q,1/x)=0
    do ite = 1,self%itemax
        ts  = 1.d0/x
        equ = f_g(self,p,q,ts)
        if (DBG) write(6,*) 'ite = ',ite,'   x = ',x,'   ts = ',ts,'   equ = ',equ
        
        ! Construction de l'encadrement et test (monotonie de la fonction)
        ofsp = f_g(self,p,q,ts + 0.5d0*cv_ts)
        ofsm = f_g(self,p,q,ts - 0.5d0*cv_ts)
        if (DBG) write(6,*) 'ofsp=',ofsp,'  ofsm=',ofsm
        ASSERT(ofsm.ge.0)
        if (ofsp.le.0.d0) exit
        
        d_equ = -dts_g(self,p,q,ts)*ts**2
        if (DBG) write (6,*) 'utnewt 7B'
        x = utnewt(x,equ,d_equ,ite,mem)
        if (DBG) write (6,*) 'utnewt 7E'
    end do
    if (ite.gt.self%itemax) then
        self%exception = 1
        goto 999
    end if     
    
    ! On fournit la borne inferieure de l'encadrement (inferieure a la valeur reelle)   
    ts = ts - 0.5d0*cv_ts

999 continue
    if (DBG) write(6,*) 'END Compute_Star'
end function Compute_Star




! =====================================================================
!  COMPUTATION OF NUCLEATION POROSITY 
! =====================================================================

real(kind=8) function Nucleation(self,ka,ep)

    implicit none

    type(CONSTITUTIVE_LAW),intent(in):: self
    real(kind=8),intent(in)::ka,ep
! --------------------------------------------------------------------------------------------------
! ka        hardening variable
! ep        cumulated plastic strain
! --------------------------------------------------------------------------------------------------
    real(kind=8):: fgauss, fcran, feps
! --------------------------------------------------------------------------------------------------
    if (DBG) write(6,*) 'BEGIN Nucleation'

    fgauss = 0.5d0*self%mat%fn*(erf((ka-self%mat%pn)/sqrt(2.d0)/self%mat%sn) + &
                                erf(self%mat%pn/sqrt(2.d0)/self%mat%sn))
    fcran  = max(0.d0, min(self%mat%c0/(self%mat%kf - self%mat%ki)*(ka-self%mat%ki),self%mat%c0))
    feps   = self%mat%b0*max(ep-self%mat%epc,0.d0)
    Nucleation = fgauss + fcran + feps

    if (DBG) write(6,*) 'END Nucleation'
end function Nucleation




! =====================================================================
!  UPDATE POROSITY (NUCLEATION AND GROWTH)
! =====================================================================
subroutine Update_porosity(self,epm,ep,ka,epcum,f,fnuc)
    implicit none
    type(CONSTITUTIVE_LAW),intent(in):: self
    real(kind=8),intent(in):: epm(:),ep(:),ka
    real(kind=8),intent(inout):: epcum,f,fnuc
! --------------------------------------------------------------------------------------------------
! eps       deformation a la fin du pas de temps
! ka        variable d'ecrouissage kappa (in=debut pas de temps, out=fin)
! f         porosity (in=t-, out=t+)
! state     etat pendant le pas (0=elastique, 1=plastique, 2=singulier) (in=debut, out=fin)
! ep        deformation plastique (in=debut, out=fin)
! epcum     cumulated plastic strain
! fnuc      nucleation porosity
! t         contrainte en fin de pas de temps (resi) ou au debut du pas de temps (not resi)
! deps_t    derivee dt / deps
! dphi_t    derivee dt / dphi   (grad_vari)
! deps_ka   derivee dka / deps  (grad_vari)
! dphi_ka   derivee dka / dphi  (grad_vari)
! --------------------------------------------------------------------------------------------------
    real(kind=8):: fm, fnucm, fgrom, fgro, coef, dep(size(ep)),deph
! --------------------------------------------------------------------------------------------------
    fm    = f
    fnucm = fnuc
    fgrom = fm-fnucm
    dep   = ep-epm
    deph  = sum(dep(1:3)) / 3.d0
    
    epcum = epcum + sqrt(2.d0/3.d0 * dot_product(dep,dep))
    fnuc  = Nucleation(self,ka,epcum)
    fgro  = max( ((1-fnuc)*3*deph + fgrom) / (1+3*deph), self%mat%f0)
    f     = fnuc + fgro
    
    ! If porosity goes over fracture porosity :
    ! proporitional correction of fnuc and fgro to reach exactly fr
    if (f .gt. self%mat%fr) then
        coef = (self%mat%fr - fm)/(f-fm)
        fnuc = fnucm + coef*(fnuc-fnucm)
        f    = self%mat%fr
    end if    
end subroutine Update_porosity
    


    
! =====================================================================
!  RESPONSE OF A BROKEN POINT 
! =====================================================================

subroutine Broken_Point(self, eps, ka, f, state, ep, &
                  epcum, fnuc, t, deps_t, dphi_t,deps_ka,dphi_ka) 

    implicit none

    type(CONSTITUTIVE_LAW),intent(inout):: self
    real(kind=8),intent(in)             :: eps(:)
    real(kind=8),intent(inout)          :: ep(:),ka, f, epcum, fnuc
    integer,intent(inout)               :: state
    real(kind=8),intent(out)            :: t(:),deps_t(:,:)
    real(kind=8),intent(out)            :: dphi_t(:),deps_ka(:),dphi_ka
! --------------------------------------------------------------------------------------------------
! eps       deformation a la fin du pas de temps
! ka        variable d'ecrouissage kappa (in=debut pas de temps, out=fin)
! f         porosity (in=t-, out=t+)
! state     etat pendant le pas (0=elastique, 1=plastique, 2=singulier) (in=debut, out=fin)
! ep        deformation plastique (in=debut, out=fin)
! epcum     cumulated plastic strain
! fnuc      nucleation porosity
! t         contrainte en fin de pas de temps (resi) ou au debut du pas de temps (not resi)
! deps_t    derivee dt / deps
! dphi_t    derivee dt / dphi   (grad_vari)
! deps_ka   derivee dka / deps  (grad_vari)
! dphi_ka   derivee dka / dphi  (grad_vari)
! --------------------------------------------------------------------------------------------------
    state = 3
    t     = 0.d0
    epcum = epcum + sqrt(2.d0/3.d0*dot_product(eps-ep,eps-ep))
    ep    = eps
    f     = self%mat%fr
    if (self%rigi) then
        deps_t  = 0.d0
        dphi_t  = 0.d0
        deps_ka = 0.d0
        dphi_ka = 0.d0
    end if
end subroutine Broken_Point




! ----------------------------------------------------------------------------------------
!  Liste des fonctions intermediaires et leurs derivees
!   --> Derivees: djac_*, dteh_*, dteq_*, dphi_*
! ----------------------------------------------------------------------------------------


real(kind=8) function f_g(self,q,p,ts)
    implicit none
    type(CONSTITUTIVE_LAW),intent(inout):: self
    real(kind=8)::q,p,ts
    f_g = (self%telq*q/ts)**2 + 2*self%q1f*cosh(1.5d0*self%mat%q2*self%telh*p/ts)-1-self%q1f**2
end function f_g

real(kind=8) function dq_g(self,q,p,ts)
    implicit none
    type(CONSTITUTIVE_LAW),intent(inout):: self
    real(kind=8)::q,p,ts
    dq_g = 2*self%telq**2*q/ts**2 
end function dq_g

real(kind=8) function dp_g(self,q,p,ts)
    implicit none
    type(CONSTITUTIVE_LAW),intent(inout):: self
    real(kind=8)::q,p,ts
    dp_g = 3*self%q1f*self%mat%q2*self%telh/ts*sinh(1.5d0*self%mat%q2*self%telh*p/ts)
end function dp_g

real(kind=8) function dts_g(self,q,p,ts)
    implicit none
    type(CONSTITUTIVE_LAW),intent(inout):: self
    real(kind=8)::q,p,ts
    dts_g = -2*(self%telq*q)**2/ts**3 - 3*self%q1f*self%mat%q2*self%telh*p/ts**2 &
                                        *sinh(1.5d0*self%mat%q2*self%telh*p/ts)
end function dts_g

real(kind=8) function dteh_g(self,q,p,ts)
    implicit none
    type(CONSTITUTIVE_LAW),intent(inout):: self
    real(kind=8)::q,p,ts
    dteh_g = 3*self%q1f*self%mat%q2*p/ts*sinh(1.5d0*self%mat%q2*self%telh*p/ts)
end function dteh_g

real(kind=8) function dteq_g(self,q,p,ts)
    implicit none
    type(CONSTITUTIVE_LAW),intent(inout):: self
    real(kind=8)::q,p,ts
    dteq_g = 2*self%telq*(q/ts)**2
end function dteq_g




real(kind=8) function f_ecro(self,ka)
    implicit none
    type(CONSTITUTIVE_LAW),intent(inout):: self
    real(kind=8)::ka
    f_ecro = self%mat%r0+self%mat%rh*ka+self%mat%r1*(1-exp(-self%mat%g1*ka)) &
             + self%mat%r2*(1-exp(-self%mat%g2*ka))+self%mat%rk*(ka+self%mat%p0)**self%mat%gk
end function f_ecro

real(kind=8) function dka_ecro(self,ka)
    implicit none
    type(CONSTITUTIVE_LAW),intent(inout):: self
    real(kind=8)::ka
    dka_ecro = self%mat%rh+self%mat%r1*self%mat%g1*exp(-self%mat%g1*ka) &
                +self%mat%r2*self%mat%g2*exp(-self%mat%g2*ka) &
                +self%mat%rk*self%mat%gk*(ka+self%mat%p0)**(self%mat%gk-1)
end function dka_ecro




real(kind=8) function f_ts_hat(self,dka,kv)
    implicit none
    type(CONSTITUTIVE_LAW),intent(inout):: self
    real(kind=8),intent(in),optional::dka,kv
    real(kind=8):: vsc,ka
    
    ! one and one only among dka and kv is given
    ASSERT(present(dka) .eqv. .not.present(kv))
    
    if (present(dka)) then
        vsc = f_vsc(self%visco,dka=dka)
        ka  = self%kam + dka
    else
        vsc = f_vsc(self%visco,kv=kv)
        ka  = self%kam + f_dka(self%visco,kv)
    end if
    
    f_ts_hat = self%jac*(f_ecro(self,ka) + self%mat%r*ka - self%phi + vsc)
end function f_ts_hat


real(kind=8) function dkv_ts_hat(self,kv)
    implicit none
    type(CONSTITUTIVE_LAW),intent(inout):: self
    real(kind=8)::kv
    real(kind=8):: ka
    
    ka  = self%kam + f_dka(self%visco,kv)   
    dkv_ts_hat = self%jac*( (dka_ecro(self,ka) + self%mat%r)*dkv_dka(self%visco,kv) &
                            + dkv_vsc(self%visco,kv) )
end function dkv_ts_hat


real(kind=8) function dka_ts_hat(self,dka)
    implicit none
    type(CONSTITUTIVE_LAW),intent(inout):: self
    real(kind=8)::dka
    
    dka_ts_hat = self%jac*(dka_ecro(self,self%kam+dka) + self%mat%r + ddka_vsc(self%visco,dka))
end function dka_ts_hat


real(kind=8) function djac_ts_hat(self,dka)
    implicit none
    type(CONSTITUTIVE_LAW),intent(inout):: self
    real(kind=8)::dka
    real(kind=8)::ka
    ka = self%kam + dka
    djac_ts_hat = f_ecro(self,ka) + self%mat%r*ka - self%phi + f_vsc(self%visco,dka)
end function djac_ts_hat


real(kind=8) function dphi_ts_hat(self,dka)
    implicit none
    type(CONSTITUTIVE_LAW),intent(inout):: self
    real(kind=8)::dka
    dphi_ts_hat = -self%jac
end function dphi_ts_hat



real(kind=8) function f_lambda(self,x)
    implicit none
    type(CONSTITUTIVE_LAW),intent(inout):: self
    real(kind=8)::x
    f_lambda = 0.5d0*self%q1f*self%mat%q2*sinh(1.5d0*self%mat%q2*x)
end function f_lambda

real(kind=8) function dx_lambda(self,x)
    implicit none
    type(CONSTITUTIVE_LAW),intent(inout):: self
    real(kind=8)::x
    dx_lambda = 0.75d0*self%q1f*self%mat%q2**2*cosh(1.5d0*self%mat%q2*x)
end function dx_lambda



real(kind=8) function f_theta(self,x,y)
    implicit none
    type(CONSTITUTIVE_LAW),intent(inout):: self
    real(kind=8)::x,y
    f_theta = 1.d0/(y**2 + 3*x*f_lambda(self,x))
end function f_theta

real(kind=8) function dx_theta(self,x,y)
    implicit none
    type(CONSTITUTIVE_LAW),intent(inout):: self
    real(kind=8)::x,y
    real(kind=8)::lbd
    lbd = f_lambda(self,x)
    dx_theta = -3*(lbd + x*dx_lambda(self,x))/(y**2 + 3*x*lbd)**2
end function dx_theta

real(kind=8) function dy_theta(self,x,y)
    implicit none
    type(CONSTITUTIVE_LAW),intent(inout):: self
    real(kind=8)::x,y
    dy_theta = -(2*y)/(y**2 + 3*x*f_lambda(self,x))**2
end function dy_theta



real(kind=8) function f_q_hat(self,p,ts)
    implicit none
    type(CONSTITUTIVE_LAW),intent(inout):: self
    real(kind=8)::p,ts
    real(kind=8)::muk,num,den
    muk = self%mat%troismu/self%mat%troisk
    num = ts*f_lambda(self,self%telh*p/ts)
    den = num + muk*self%telh*(1-p)
    f_q_hat = num/den
end function f_q_hat

real(kind=8) function dp_q_hat(self,p,ts)
    implicit none
    type(CONSTITUTIVE_LAW),intent(inout):: self
    real(kind=8)::p,ts
    real(kind=8)::muk,num,den,d_num,d_den
    muk = self%mat%troismu/self%mat%troisk
    num = ts*f_lambda(self,self%telh*p/ts)
    den = num + muk*self%telh*(1-p)
    d_num = dx_lambda(self,self%telh*p/ts)*self%telh
    d_den = d_num - muk*self%telh
    dp_q_hat = (d_num*den-num*d_den)/den**2
end function dp_q_hat

real(kind=8) function dts_q_hat(self,p,ts)
    implicit none
    type(CONSTITUTIVE_LAW),intent(inout):: self
    real(kind=8)::p,ts
    real(kind=8)::muk,num,den,lbd,d_num,d_den
    muk = self%mat%troismu/self%mat%troisk
    lbd = f_lambda(self,self%telh*p/ts)
    num = ts*lbd
    den = num + muk*self%telh*(1-p)
    d_num = lbd - dx_lambda(self,self%telh*p/ts)*(self%telh*p/ts)
    d_den = d_num 
    dts_q_hat = (d_num*den-num*d_den)/den**2
end function dts_q_hat

real(kind=8) function dteh_q_hat(self,p,ts)
    implicit none
    type(CONSTITUTIVE_LAW),intent(inout):: self
    real(kind=8)::p,ts
    real(kind=8)::muk,w,num,d_num,den,d_den,lbd0,a0p,seuil
    muk = self%mat%troismu/self%mat%troisk
    w   = 1.5d0*self%mat%q2*self%telh*p/ts
    seuil = (r8prem()*1200)**0.25d0
    if (abs(w).le.seuil) then
        ! Precision numerique quand telh petit (dvp limite de lambda ordre 4)
        lbd0 = 0.5d0*self%q1f*self%mat%q2
        a0p  = 1.5d0*self%mat%q2*p
        dteh_q_hat = (12*(a0p)**3*lbd0*muk*(1-p)*ts**2*self%telh) & 
                   / (lbd0*a0p*(6*ts**2+(a0p*self%telh)**2) + 6*muk*ts**2*(1-p))**2
    else
        ! Derivee normale de lambda avec le sinh
        num = ts*f_lambda(self,self%telh*p/ts)
        d_num = dx_lambda(self,self%telh*p/ts)*p
        den = num + muk*self%telh*(1-p)
        d_den = d_num + muk*(1-p)
        dteh_q_hat = (d_num*den-num*d_den)/den**2
    end if
end function dteh_q_hat



real(kind=8) function f_g_hat(self,p,ts)
    implicit none
    type(CONSTITUTIVE_LAW),intent(inout):: self
    real(kind=8)::p,ts
    real(kind=8)::q
    q = f_q_hat(self,p,ts)
    f_g_hat = f_g(self,q,p,ts)
end function f_g_hat

real(kind=8) function dp_g_hat(self,p,ts)
    implicit none
    type(CONSTITUTIVE_LAW),intent(inout):: self
    real(kind=8)::p,ts
    real(kind=8)::q
    q = f_q_hat(self,p,ts)
    dp_g_hat = dq_g(self,q,p,ts)*dp_q_hat(self,p,ts) + dp_g(self,q,p,ts)
end function dp_g_hat

real(kind=8) function dts_g_hat(self,p,ts)
    implicit none
    type(CONSTITUTIVE_LAW),intent(inout):: self
    real(kind=8)::p,ts
    real(kind=8)::q
    q = f_q_hat(self,p,ts)
    dts_g_hat = dq_g(self,q,p,ts)*dts_q_hat(self,p,ts) + dts_g(self,q,p,ts)
end function dts_g_hat

real(kind=8) function dteh_g_hat(self,p,ts)
    implicit none
    type(CONSTITUTIVE_LAW),intent(inout):: self
    real(kind=8)::p,ts
    real(kind=8)::q,d_q
    q = f_q_hat(self,p,ts)
    d_q = dteh_q_hat(self,p,ts)
    dteh_g_hat = dq_g(self,q,p,ts)*d_q + dteh_g(self,q,p,ts)
end function dteh_g_hat

real(kind=8) function dteq_g_hat(self,p,ts)
    implicit none
    type(CONSTITUTIVE_LAW),intent(inout):: self
    real(kind=8)::p,ts
    real(kind=8)::q
    q = f_q_hat(self,p,ts)
    dteq_g_hat = dteq_g(self,q,p,ts)
end function dteq_g_hat



real(kind=8) function f_lbd_hat(self,p,ts)
    implicit none
    type(CONSTITUTIVE_LAW),intent(inout):: self
    real(kind=8)::p,ts
    real(kind=8)::jk,q,num,den,lbd,the
    jk = self%jac/self%mat%troisk
    q  = f_q_hat(self,p,ts)
    lbd = f_lambda(self,self%telh*p/ts)
    the = f_theta(self,self%telh*p/ts,self%telq*q/ts)
    num = jk*self%telh*(1-p)
    den = the*lbd
    f_lbd_hat = num/den
end function f_lbd_hat

real(kind=8) function dp_lbd_hat(self,p,ts)
    implicit none
    type(CONSTITUTIVE_LAW),intent(inout):: self
    real(kind=8)::p,ts
    real(kind=8)::jk,q,d_q,lbd,d_lbd,the,d_the,num,d_num,den,d_den
    jk = self%jac/self%mat%troisk
    q = f_q_hat(self,p,ts)
    d_q = dp_q_hat(self,p,ts)
    lbd = f_lambda(self,self%telh*p/ts)
    d_lbd = dx_lambda(self,self%telh*p/ts)*self%telh/ts
    the = f_theta(self,self%telh*p/ts,self%telq*q/ts)
    d_the = dx_theta(self,self%telh*p/ts,self%telq*q/ts)*self%telh/ts &
            + dy_theta(self,self%telh*p/ts,self%telq*q/ts)*self%telq/ts*d_q
    num = jk*self%telh*(1-p)
    d_num = -jk*self%telh
    den = the*lbd
    d_den = d_the*lbd + the*d_lbd
    dp_lbd_hat = (d_num*den-num*d_den)/den**2
end function dp_lbd_hat

real(kind=8) function dts_lbd_hat(self,p,ts)
    implicit none
    type(CONSTITUTIVE_LAW),intent(inout):: self
    real(kind=8)::p,ts
    real(kind=8)::jk,q,d_q,lbd,d_lbd,the,d_the,num,den,d_den
    jk = self%jac/self%mat%troisk
    q = f_q_hat(self,p,ts)
    d_q = dts_q_hat(self,p,ts)
    lbd = f_lambda(self,self%telh*p/ts)
    d_lbd = dx_lambda(self,self%telh*p/ts)*(-self%telh*p/ts**2)
    the = f_theta(self,self%telh*p/ts,self%telq*q/ts)
    d_the = dx_theta(self,self%telh*p/ts,self%telq*q/ts)*(-self%telh*p/ts**2) &
          + dy_theta(self,self%telh*p/ts,self%telq*q/ts)*self%telq*(d_q*ts-q)/ts**2
    num = jk*self%telh*(1-p)
    den = the*lbd
    d_den = d_the*lbd + the*d_lbd
    dts_lbd_hat = -num*d_den/den**2
end function dts_lbd_hat

real(kind=8) function djac_lbd_hat(self,p,ts)
    implicit none
    type(CONSTITUTIVE_LAW),intent(inout):: self
    real(kind=8)::p,ts
    real(kind=8)::jk,d_jk,q,num,d_num,den,lbd,the
    jk = self%jac/self%mat%troisk
    d_jk = 1/self%mat%troisk
    q  = f_q_hat(self,p,ts)
    lbd = f_lambda(self,self%telh*p/ts)
    the = f_theta(self,self%telh*p/ts,self%telq*q/ts)
    num = jk*self%telh*(1-p)
    d_num = d_jk*self%telh*(1-p)
    den = the*lbd
    djac_lbd_hat = d_num/den
end function djac_lbd_hat

real(kind=8) function dteh_lbd_hat(self,p,ts)
    implicit none
    type(CONSTITUTIVE_LAW),intent(inout):: self
    real(kind=8)::p,ts
    real(kind=8)::jk,q,d_q,num,d_num,den,d_den,lbd,d_lbd,the,d_the
    jk = self%jac/self%mat%troisk
    q = f_q_hat(self,p,ts)
    d_q = dteh_q_hat(self,p,ts)
    lbd = f_lambda(self,self%telh*p/ts)
    d_lbd = dx_lambda(self,self%telh*p/ts)*p/ts
    the = f_theta(self,self%telh*p/ts,self%telq*q/ts)
    d_the = dx_theta(self,self%telh*p/ts,self%telq*q/ts)*p/ts &
            + dy_theta(self,self%telh*p/ts,self%telq*q/ts)*self%telq*d_q/ts
    num = jk*self%telh*(1-p)
    d_num = jk*(1-p)
    den = the*lbd
    d_den = d_the*lbd + the*d_lbd
    dteh_lbd_hat = (d_num*den - num*d_den)/den**2
end function dteh_lbd_hat

real(kind=8) function dteq_lbd_hat(self,p,ts)
    implicit none
    type(CONSTITUTIVE_LAW),intent(inout):: self
    real(kind=8)::p,ts
    real(kind=8)::jk,q,num,den,d_den,lbd,the,d_the
    jk = self%jac/self%mat%troisk
    q  = f_q_hat(self,p,ts)
    lbd = f_lambda(self,self%telh*p/ts)
    the = f_theta(self,self%telh*p/ts,self%telq*q/ts)
    d_the = dy_theta(self,self%telh*p/ts,self%telq*q/ts)*q/ts
    num = jk*self%telh*(1-p)
    den = the*lbd
    d_den = d_the*lbd
    dteq_lbd_hat = -num*d_den/den**2
end function dteq_lbd_hat




real(kind=8) function dp_m_hat(self,p,ts,dka)
    implicit none
    type(CONSTITUTIVE_LAW),intent(inout):: self
    real(kind=8)::p,ts,dka
    dp_m_hat = -dp_lbd_hat(self,p,ts)
end function dp_m_hat

real(kind=8) function dts_m_hat(self,p,ts,dka)
    implicit none
    type(CONSTITUTIVE_LAW),intent(inout):: self
    real(kind=8)::p,ts,dka
    dts_m_hat = 1.d0/dka_ts_hat(self,dka) - dts_lbd_hat(self,p,ts)
end function dts_m_hat

real(kind=8) function djac_m_hat(self,p,ts,dka)
    implicit none
    type(CONSTITUTIVE_LAW),intent(inout):: self
    real(kind=8)::p,ts,dka
    djac_m_hat = -djac_ts_hat(self,dka)/dka_ts_hat(self,dka) - djac_lbd_hat(self,p,ts)
end function djac_m_hat

real(kind=8) function dphi_m_hat(self,p,ts,dka)
    implicit none
    type(CONSTITUTIVE_LAW),intent(inout):: self
    real(kind=8)::p,ts,dka
    dphi_m_hat = -dphi_ts_hat(self,dka)/dka_ts_hat(self,dka) 
end function dphi_m_hat

real(kind=8) function dteh_m_hat(self,p,ts,dka)
    implicit none
    type(CONSTITUTIVE_LAW),intent(inout):: self
    real(kind=8)::p,ts,dka
    dteh_m_hat = - dteh_lbd_hat(self,p,ts)
end function dteh_m_hat

real(kind=8) function dteq_m_hat(self,p,ts,dka)
    implicit none
    type(CONSTITUTIVE_LAW),intent(inout):: self
    real(kind=8)::p,ts,dka
    dteq_m_hat = - dteq_lbd_hat(self,p,ts)
end function dteq_m_hat



end module lcgtn_module
