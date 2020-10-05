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

module lcgtn_module

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
#include "asterc/r8nnem.h"
#include "asterc/r8pi.h"
#include "asterc/r8prem.h"
#include "asterfort/assert.h"
#include "asterfort/lcgrad.h"
#include "asterfort/rcvalb.h"
#include "asterfort/utmess.h"



    ! Material characteristics
    type MATERIAL
        real(kind=8) :: lambda,deuxmu,troismu,troisk
        real(kind=8) :: r0,rh,r1,g1,r2,g2,rk,p0,gk
        real(kind=8) :: q1,q2,f0,fc,fr
        real(kind=8) :: fn,pn,sn,c0,kf,ki,epc,b0
        real(kind=8) :: c  = 0.d0
        real(kind=8) :: r  = 0.d0
        real(kind=8) :: v0 = 0.d0
        real(kind=8) :: q  = 2.d0
    end type MATERIAL



    ! GTN class
    type CONSTITUTIVE_LAW
        integer       :: exception = 0
        aster_logical :: elas,rigi,resi,vari,pred
        aster_logical :: grvi = ASTER_FALSE
        aster_logical :: visc = ASTER_FALSE
        integer       :: ndimsi,itemax
        real(kind=8)  :: cvuser
        real(kind=8)  :: phi = 0.d0
        real(kind=8)  :: telh 
        real(kind=8)  :: telq 
        real(kind=8)  :: q1f 
        real(kind=8)  :: jac 
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
    real(kind=8)    :: ka,f,ep(self%ndimsi),rac2(self%ndimsi)
    real(kind=8)    :: vdum1(self%ndimsi), vdum2(self%ndimsi), rdum
    real(kind=8)    :: epcum,fnuc,poro_log
! --------------------------------------------------------------------------------------------------

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
        call ComputePlasticity(self, eps, ka, f, state, ep, epcum, fnuc, sig, deps_sig, dphi_sig, deps_vi, dphi_vi)
    else
        call ComputePlasticity(self, eps, ka, f, state, ep, epcum, fnuc, sig, deps_sig, vdum1, vdum2, rdum)
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
! t         contrainte en fin de pas de temps
! deps_t    derivee dt / deps
! dphi_t    derivee dt / dphi   (grad_vari)
! deps_ka   derivee dka / deps  (grad_vari)
! dphi_ka   derivee dka / dphi  (grad_vari)
! --------------------------------------------------------------------------------------------------
    integer     :: ite,iteint,iteext,i
    real(kind=8):: kr(size(eps)),presig,jac,fg,q1f,kam,epmh
    real(kind=8):: fm, fnucm, fgrom, fgro, coef
    real(kind=8):: tel(size(eps)),telh,telq,teld(size(eps)),tels
    real(kind=8):: tsm,tsmax
    real(kind=8):: gamm1,deph,depd(size(eps)),depq,pin,chim1,cs
    real(kind=8):: kamin,tsmin
    real(kind=8):: equ,d_equ,equint,equext,d_equint,d_equext,p,q,ts
    real(kind=8):: pmin,pmax,p1,p2,fg1,fg2,m1,m2,offset,xm,xp,equm,equp,sgn,dts_p
    type(newton_state):: mem,memint,memext
    real(kind=8):: lambda_bar,deuxmu_bar
    real(kind=8):: mat(2,2),vec(2)
    real(kind=8):: djac_p,dteh_p,dteq_p,dphi_p,deps_p(size(eps))
    real(kind=8):: deps_jac(size(eps)),deps_teh(size(eps)),deps_teq(size(eps))
    real(kind=8):: dp_q,dts_q,djac_q,dteh_q,dteq_q,dphi_q,deps_q(size(eps))
    real(kind=8):: djac_ts,dteh_ts,dteq_ts,dphi_ts
    real(kind=8):: djac_ka,dteh_ka,dteq_ka
    real(kind=8):: dp_lbd,dts_lbd
    real(kind=8):: dka_ts
! ----------------------------------------------------------------------

!   Initialisation
    kr      = kron(self%ndimsi)
    kam     = ka
    jac     = exp(sum(eps(1:3)))
    presig  = min(jac,1.d0)*f_ecro(self,0.d0)*self%cvuser
    epmh    = sum(ep(1:3))/3.d0


!   Contrainte elastique
    tel  = self%mat%lambda*sum(eps(1:3)-ep(1:3))*kr + self%mat%deuxmu*(eps-ep)
    telh = sum(tel(1:3)) / 3.d0
    teld = tel - telh*kr
    telq = sqrt(1.5d0 * dot_product(teld,teld))


!   Perturbation en presig*1e-3 pour eviter la singularite TELH=0
    telh    = sign(max(presig*1.d-3, abs(telh)) , telh)


!   Calcul de la porosite effective (coalescence)
    if (f.le.self%mat%fc) then
        q1f = self%mat%q1 * f 
    else
        q1f = self%mat%q1*self%mat%fc + (1-self%mat%q1*self%mat%fc)/(self%mat%fr-self%mat%fc)*(f-self%mat%fc)
    end if
    ASSERT(q1f.gt.0 .and. q1f.le.1)


!   Copie des informations dans self pour utilisation des fonctions du module
    self%kam  = kam
    self%telh = telh
    self%telq = telq
    self%q1f  = q1f
    self%jac  = jac


!   Niveau d'ecrouissage
    tsm = f_ts_hat(self,kam)

    

! ======================================================================
!               INTEGRATION DE LA LOI DE COMPORTEMENT
! ======================================================================

    if (.not. self%resi) goto 800



! ----------------------------------------------------------------------
!   CAS D'UN POINT TOTALEMENT ROMPU (q1.f* == 1)
! ----------------------------------------------------------------------

    if ((1-q1f) .le. sqrt(self%cvuser)) then
        state = 3
        t = 0
        goto 500
    end if



! ----------------------------------------------------------------------
!  REGIME ELASTIQUE
! ----------------------------------------------------------------------

!   Borne sur la contrainte T*
    tsmax   = tsm + presig

!   Filtre pour eviter les erreurs numeriques
    if (tsmax.le.0) goto 100
    if (telq.gt.tsmax*sqrt(1+q1f**2)) goto 100
    if (1.5d0*self%mat%q2*telh .gt. tsmax*acosh((1+q1f**2)/(2*q1f))) goto 100

!   Borne du critere elastique
    if (f_g(self,1.d0,1.d0,tsmax).le.0) then
        state = 0
        t = tel
        goto 500
    end if
100 continue




! ----------------------------------------------------------------------
!  REGIME PLASTIQUE SINGULIER
! ----------------------------------------------------------------------

   
!   Test simple: s(ka-) > 0 -> pas singulier (cas du modele local, entre autres)
    if (tsm.gt.presig) goto 200
    
!   Borne inferieure fournie par la condition de singularite
    gamm1 = (1-q1f)**2 / (2*q1f)
    deph  = telh/self%mat%troisk
    depd  = teld/self%mat%deuxmu
    depq  = telq/self%mat%deuxmu
    if (deph**2 + depq**2 .eq. 0) then
      pin = 0
    else
        chim1 = (self%mat%q2*depq)**2 / (9*deph**2/q1f + (self%mat%q2*depq)**2)
        cs    = 2*gamm1*(1-chim1)/(1+sqrt(1+2*gamm1*chim1*(1-chim1)))
        pin   = 2/self%mat%q2*acosh(1+cs)*abs(deph) + 2.d0/3.d0*(1-q1f)*sqrt(1-cs/gamm1)*depq
    end if
    kamin = kam + jac*pin

!   Valeur du critere sur la borne
    tsmin = f_ts_hat(self,kamin) 
    if (tsmin.gt.presig) goto 200

!   La solution est singuliere : calcul de ka via Ts_hat(ka)==0
    ka = kamin
    do ite = 1,self%itemax
        equ   = f_ts_hat(self,ka) 
        d_equ = dka_ts_hat(self,ka)
        if (abs(equ).le.presig) exit
        ka = utnewt(ka,equ,d_equ,ite,mem)
    end do
    if (ite.gt.self%itemax) then
        self%exception = 1
        goto 999
    end if
    
    ep  = ep + deph*kr + depd
    t   = 0
    state = 2
    goto 500
    
200 continue 
    

    
    
! ----------------------------------------------------------------------
!  REGIME PLASTIQUE REGULIER
! ----------------------------------------------------------------------


! 1. Calcul de Tel* avec une precision prec/10 et tel que 0<G(Te,Te*)<prec/10 (convexite)

    ! Borne min
    tels = max(telq/(1-q1f),1.5d0*self%mat%q2*abs(telh)/acosh(1+0.5d0*(1-q1f)**2/q1f))

    ! Resolution G(Tel,Tel*)=0
    do iteint = 1,self%itemax
        equ   = f_g(self,1.d0,1.d0,tels)
        if (abs(equ).le.self%cvuser*1.d-1) exit
        d_equ = dts_g(self,1.d0,1.d0,tels)
        tels = utnewt(tels,-equ,-d_equ,iteint,mem)
    end do
    if (iteint.gt.self%itemax) then
        self%exception = 1
        goto 999
    end if        


! 2. Resolution du systeme non lineaire de deux equations

    ! Estimation initiale par resolution du probleme de von Mises
    ts = tels
    
    if (f_ts_hat(self,kam+jac*(1-q1f)/self%mat%troismu*tels) .le. presig) then
    
        ! Cas von Mises singulier (possible meme si GTN regulier)
        ts = 1.5d0*self%mat%q2*abs(telh)/acosh(1+0.5d0*(1-q1f)**2/q1f)
        
    else
        ! Cas von Mises regulier
        do iteint = 1,self%itemax
            ka = kam + jac*(1-q1f)/self%mat%troismu*(tels-ts)
            equ   = ts - f_ts_hat(self,ka)
            if (abs(equ).le.presig) exit
            d_equ = 1 + jac/self%mat%troismu*dka_ts_hat(self,ka)
            ts = utnewt(ts,equ,d_equ,iteint,mem,xmin=0.d0,xmax=tels)
        end do
        if (iteint.gt.self%itemax) then
            self%exception = 1
            goto 999
        end if        
    end if

    ! Resolution de M_hat(p(ts),ts) == 0
    do iteext = 1,self%itemax

        ! 2.1 Resolution de G_hat(p,ts) == 0 par rapport a p
        pmin = bnd_pmin(self,ts)
        pmax = bnd_pmax(self,ts)
        p1   = pmax
        do iteint = 1,self%itemax
            equint   = f_g_hat(self,p1,ts)
            d_equint = dp_g_hat(self,p1,ts)
            if (abs(equint).le.self%cvuser) exit
            p1 = utnewt(p1,equint,d_equint,iteint,memint,xmin=pmin,xmax=pmax, &
                        usemin=to_aster_logical(pmin.ne.0.d0))
        end do
        if (iteint.gt.self%itemax) then
            self%exception = 1
            goto 999
        end if        
        fg1 = equint
        m1  = f_m_hat(self,p1,ts)
        if (abs(m1).le.presig) then
            p = p1
            exit        
        end if


        ! 2.2 Recherche d'un encadrement de la solution p tel que G_hat(p,ts)=0

        ! Intervalle de recherche
        if (fg1.le.0) then
            offset  = -0.5d0*self%cvuser
            xm   = p1
            xp   = pmax
            equm = fg1 + offset
            equp = f_g_hat(self,pmax,ts) + offset
        else
            offset  =  0.5d0*self%cvuser
            xm   = pmin
            xp   = p1
            equm = f_g_hat(self,pmin,ts) + offset
            equp = fg1 + offset
        end if

        ! Recherche de la seconde borne
        if (equm .ge. -0.1d0*self%cvuser) then
            p2 = xm
            fg2 = equm-offset
        else if (equp .le. 0.1d0*self%cvuser) then
            p2 = xp
            fg2 = equp-offset
        else
            p2 = p1
            do iteint = 1,self%itemax
                equint   = f_g_hat(self,p2,ts)+offset
                d_equint = dp_g_hat(self,p2,ts)
                if (abs(equint).le.0.1d0*self%cvuser) exit
                p2 = utnewt(p2,equint,d_equint,iteint,memint,xmin=xm,xmax=xp, &
                            usemin=to_aster_logical(xm.ne.0.d0))
            end do
            if (iteint.gt.self%itemax) then
                self%exception = 1
                goto 999
            end if        
            fg2 = equint-offset
            ASSERT(fg1*fg2 .le. 0)
        end if

        ! Valeur de p optimale (corde)
        if (equ.ge.0 .or.equp.le.0) then
            p = p2
        else
            p = (p1*fg2 - p2*fg1)/(fg2-fg1)
        end if

        ! Valeur de m sur la seconde borne
        m2  = f_m_hat(self,p2,ts)
        if (abs(m2).le.presig) then
            p = p2
            exit        
        end if


        ! 2.3 Si l'intervalle (p1,p2) permet de trouver une solution M(p,ts)=0 -> recherche de p
        if (m1*m2.lt.0) then
            ! croissance de M(p,ts) par rapport a p dans l'intervalle (p1,p2)
            sgn = sign(1.d0,p2-p1)*sign(1.d0,m2-m1)

            ! resolution dans l'intervalle
            do iteint = 1,self%itemax
                equint   = sgn*f_m_hat(self,p,ts)
                d_equint = sgn*dp_m_hat(self,p,ts)
                if (abs(equint).le.presig) exit
                p = utnewt(p,equint,d_equint,iteint,memint,xmin=min(p1,p2),xmax=max(p1,p2))
            end do
            if (iteint.gt.self%itemax) then
                self%exception = 1
                goto 999
            end if        
            exit
        end if
        

        ! 2.5 Sinon M(p,ts) <> 0 dans l'intervalle (p1,p2) -> nouvel itere pour ts
        equext = f_m_hat(self,p,ts)
        dts_p  = -dts_g_hat(self,p,ts)/dp_g_hat(self,p,ts)
        d_equext = dp_m_hat(self,p,ts)*dts_p + dts_m_hat(self,p,ts)
        ts = utnewt(ts,equext,d_equext,iteext,memext,xmin=0.d0,xmax=tels,usemin=ASTER_FALSE)

    end do
    if (iteext.gt.self%itemax) then
        self%exception = 1
        goto 999
    end if        


! 3. Actualisation des variables internes et de la contrainte
    q = f_q_hat(self,p,ts)
    state = 1
    ka    = f_lbd_hat(self,p,ts) + kam
    deph  = (1-p)*telh/self%mat%troisk
    depd  = (1-q)*teld/self%mat%deuxmu
    ep    = ep + deph*kr + depd
    t     = p*telh*kr + q*teld


    
! ----------------------------------------------------------------------
!   Actualisation de la porosite (sans impact sur les matrices tangentes car q1f inchange)   
! ----------------------------------------------------------------------

500 continue
    if (state.eq.1 .or. state.eq.2) then
        fm    = f
        fnucm = fnuc
        fgrom = fm-fnucm
        
        epcum = epcum + sqrt(2.d0/3.d0 * (3*deph**2 + dot_product(depd,depd)))
        fnuc  = Nucleation(self,ka,epcum)
        fgro  = max( ((1-fnuc)*3*deph + fgrom) / (1+3*deph), self%mat%f0)
        f     = fnuc + fgro
        
        ! If porosity goes over fracture porosity, proporitional correction of fnuc and fgro to reach exactly fr
        if (f .gt. self%mat%fr) then
            coef = (self%mat%fr - fm)/(f-fm)
            fnuc = fnucm + coef*(fnuc-fnucm)
            f    = self%mat%fr
        end if
        
    end if




! ======================================================================
!                           MATRICES TANGENTES
! ======================================================================

800 continue
    if (.not.self%rigi) goto 999

    deps_t  = 0
    dphi_t  = 0
    deps_ka = 0
    dphi_ka = 0


    if (.not. self%resi) then
        p = 1.d0
        q = 1.d0
        ts = tsm
    end if




    if (state.eq.0 .or. self%elas) then
        ! Regime elastique (seul deps_t est non nulle, egale a la matrice d'elasticite)
        deps_t(1:3,1:3) = self%mat%lambda
        do i = 1,size(eps)
            deps_t(i,i) = deps_t(i,i) + self%mat%deuxmu
        end do


    else if (state.eq.1) then
        ! Regime plastique regulier

        ! Variations des inconnues principales (p,ts)
        mat(1,1) =  dts_m_hat(self,p,ts)
        mat(1,2) = -dts_g_hat(self,p,ts)
        mat(2,1) = -dp_m_hat(self,p,ts)
        mat(2,2) =  dp_g_hat(self,p,ts)
        mat      = mat / (mat(1,1)*mat(2,2)-mat(1,2)*mat(2,1))

        vec = -matmul(mat,[dteh_g_hat(self,p,ts),dteh_m_hat(self,p,ts)])
        dteh_p  = vec(1)
        dteh_ts = vec(2)
        
        vec = -matmul(mat,[dteq_g_hat(self,p,ts),dteq_m_hat(self,p,ts)])
        dteq_p  = vec(1)
        dteq_ts = vec(2)
        
        vec = -matmul(mat,[0.d0,djac_m_hat(self,p,ts)])
        djac_p  = vec(1)
        djac_ts = vec(2)
        
        vec = -matmul(mat,[0.d0,dphi_m_hat(self,p,ts)])
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
        dp_lbd  = dp_lbd_hat(self,p,ts)
        dts_lbd = dts_lbd_hat(self,p,ts)
        dteh_ka = dp_lbd*dteh_p + dts_lbd*dteh_ts + dteh_lbd_hat(self,p,ts)
        dteq_ka = dp_lbd*dteq_p + dts_lbd*dteq_ts + dteq_lbd_hat(self,p,ts)
        djac_ka = dp_lbd*djac_p + dts_lbd*djac_ts + djac_lbd_hat(self,p,ts)
        dphi_ka = dp_lbd*dphi_p + dts_lbd*dphi_ts 
 
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
        
        
    else if (state.eq.2) then
        ! Regime singulier (deps_t et dphi_t sont nulles)
        deps_jac = jac*kr
        dka_ts  = dka_ts_hat(self,ka)
        dphi_ka = - dphi_ts_hat(self,ka)/dka_ts
        djac_ka = - djac_ts_hat(self,ka)/dka_ts
        deps_ka = djac_ka*deps_jac


    else if (state.eq.3) then
        ! Regime casse -> matrices nulles
        continue

    else
        ASSERT(.false.)
    end if




!    Fin de la routine
999  continue

end subroutine ComputePlasticity




! =====================================================================
!  COMPUTATION OF NUCLEATION POROSITY 
! =====================================================================

real(kind=8) function Nucleation(self,ka,ep)

    implicit none

    type(CONSTITUTIVE_LAW),intent(inout):: self
    real(kind=8),intent(in)::ka,ep
! --------------------------------------------------------------------------------------------------
! ka        hardening variable
! ep        cumulated plastic strain
! --------------------------------------------------------------------------------------------------
    real(kind=8):: fgauss, fcran, feps
! --------------------------------------------------------------------------------------------------   

    fgauss = 0.5d0*self%mat%fn*(erf((ka-self%mat%pn)/sqrt(2.d0)/self%mat%sn) + &
                                erf(self%mat%pn/sqrt(2.d0)/self%mat%sn))
    fcran  = max(0.d0, min(self%mat%c0/(self%mat%kf - self%mat%ki)*(ka-self%mat%ki),self%mat%c0))
    feps   = self%mat%b0*max(ep-self%mat%epc,0.d0)
    Nucleation = fgauss + fcran + feps

end function Nucleation





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
    dts_g = -2*(self%telq*q)**2/ts**3 - 3*self%q1f*self%mat%q2*self%telh*p/ts**2*sinh(1.5d0*self%mat%q2*self%telh*p/ts)
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
    f_ecro = self%mat%r0+self%mat%rh*ka+self%mat%r1*(1-exp(-self%mat%g1*ka))+self%mat%r2*(1-exp(-self%mat%g2*ka))+self%mat%rk*(ka+self%mat%p0)**self%mat%gk
end function f_ecro

real(kind=8) function dka_ecro(self,ka)
    implicit none
    type(CONSTITUTIVE_LAW),intent(inout):: self
    real(kind=8)::ka
    dka_ecro = self%mat%rh+self%mat%r1*self%mat%g1*exp(-self%mat%g1*ka)+self%mat%r2*self%mat%g2*exp(-self%mat%g2*ka)+self%mat%rk*self%mat%gk*(ka+self%mat%p0)**(self%mat%gk-1)
end function dka_ecro



!real(kind=8) function f_visco(dka)
!    real(kind=8)::dka
!    real(kind=8)::x,p
!    x = abs(dka)/(dt*self%mat%ve0) + self%mat%vd
!    p = 1.d0/self%mat%vm
!    f_visco = self%mat%vs0*asinh(x**p-self%mat%vd**p)
!end function f_visco

!real(kind=8) function ddka_visco(dka)
!    real(kind=8)::dka
!    real(kind=8)::x,p
!    x = abs(dka)/(dt*self%mat%ve0) + self%mat%vd
!    p = 1.d0/self%mat%vm
!    ddka_visco = self%mat%vs0/(dt*self%mat%ve0) * p*x**(p-1)/sqrt(1+(x**p-self%mat%vd**p)**2)
!end function ddka_visco



real(kind=8) function f_ts_hat(self,ka)
    implicit none
    type(CONSTITUTIVE_LAW),intent(inout):: self
    real(kind=8)::ka
!    f_ts_hat = self%jac*(f_ecro(self,ka) + self%mat%r*ka - self%phi + f_visco(ka-self%kam))
    f_ts_hat = self%jac*(f_ecro(self,ka) + self%mat%r*ka - self%phi )
end function f_ts_hat

real(kind=8) function dka_ts_hat(self,ka)
    implicit none
    type(CONSTITUTIVE_LAW),intent(inout):: self
    real(kind=8)::ka
!    dka_ts_hat = self%jac*(dka_ecro(ka) + self%mat%r + ddka_visco(ka-self%kam))
    dka_ts_hat = self%jac*(dka_ecro(self,ka) + self%mat%r )
end function dka_ts_hat

real(kind=8) function djac_ts_hat(self,ka)
    implicit none
    type(CONSTITUTIVE_LAW),intent(inout):: self
    real(kind=8)::ka
!    djac_ts_hat = f_ecro(self,ka) + self%mat%r*ka - self%phi + f_visco(ka-self%kam)
    djac_ts_hat = f_ecro(self,ka) + self%mat%r*ka - self%phi 
end function djac_ts_hat

real(kind=8) function dphi_ts_hat(self,ka)
    implicit none
    type(CONSTITUTIVE_LAW),intent(inout):: self
    real(kind=8)::ka
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
    d_the = dx_theta(self,self%telh*p/ts,self%telq*q/ts)*self%telh/ts + dy_theta(self,self%telh*p/ts,self%telq*q/ts)*self%telq/ts*d_q
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
    d_the = dx_theta(self,self%telh*p/ts,self%telq*q/ts)*p/ts + dy_theta(self,self%telh*p/ts,self%telq*q/ts)*self%telq*d_q/ts
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



real(kind=8) function f_m_hat(self,p,ts)
    implicit none
    type(CONSTITUTIVE_LAW),intent(inout):: self
    real(kind=8)::p,ts
    f_m_hat = ts - f_ts_hat(self,f_lbd_hat(self,p,ts)+self%kam)
end function f_m_hat

real(kind=8) function dp_m_hat(self,p,ts)
    implicit none
    type(CONSTITUTIVE_LAW),intent(inout):: self
    real(kind=8)::p,ts
    dp_m_hat = -dka_ts_hat(self,f_lbd_hat(self,p,ts)+self%kam)*dp_lbd_hat(self,p,ts)
end function dp_m_hat

real(kind=8) function dts_m_hat(self,p,ts)
    implicit none
    type(CONSTITUTIVE_LAW),intent(inout):: self
    real(kind=8)::p,ts
    dts_m_hat = 1 - dka_ts_hat(self,f_lbd_hat(self,p,ts)+self%kam)*dts_lbd_hat(self,p,ts)
end function dts_m_hat

real(kind=8) function djac_m_hat(self,p,ts)
    implicit none
    type(CONSTITUTIVE_LAW),intent(inout):: self
    real(kind=8)::p,ts
    real(kind=8)::lbd,d_lbd
    lbd = f_lbd_hat(self,p,ts)
    d_lbd = djac_lbd_hat(self,p,ts)
    djac_m_hat = - djac_ts_hat(self,lbd+self%kam) - dka_ts_hat(self,lbd+self%kam)*d_lbd
end function djac_m_hat

real(kind=8) function dphi_m_hat(self,p,ts)
    implicit none
    type(CONSTITUTIVE_LAW),intent(inout):: self
    real(kind=8)::p,ts
    real(kind=8)::lbd
    lbd = f_lbd_hat(self,p,ts)
    dphi_m_hat = -dphi_ts_hat(self,lbd+self%kam)
end function dphi_m_hat

real(kind=8) function dteh_m_hat(self,p,ts)
    implicit none
    type(CONSTITUTIVE_LAW),intent(inout):: self
    real(kind=8)::p,ts
    real(kind=8)::lbd,d_lbd
    lbd = f_lbd_hat(self,p,ts)
    d_lbd = dteh_lbd_hat(self,p,ts)
    dteh_m_hat = -dka_ts_hat(self,lbd+self%kam)*d_lbd
end function dteh_m_hat

real(kind=8) function dteq_m_hat(self,p,ts)
    implicit none
    type(CONSTITUTIVE_LAW),intent(inout):: self
    real(kind=8)::p,ts
    real(kind=8)::lbd,d_lbd
    lbd = f_lbd_hat(self,p,ts)
    d_lbd = dteq_lbd_hat(self,p,ts)
    dteq_m_hat = -dka_ts_hat(self,lbd+self%kam)*d_lbd
end function dteq_m_hat




real(kind=8) function bnd_pmin(self,ts)
    implicit none
    type(CONSTITUTIVE_LAW),intent(inout):: self
    real(kind=8)::ts
    real(kind=8)::chm
    if (self%telq.ge.ts*(1-self%q1f)) then
        bnd_pmin = 0.d0
    else
        chm = abs((1-self%q1f)**2 - (self%telq/ts)**2)/(2*self%q1f)
        bnd_pmin = ts/abs(self%telh)*2/(3*self%mat%q2)*acosh(chm+1)
    end if
end function bnd_pmin


real(kind=8) function bnd_pmax(self,ts)
    implicit none
    type(CONSTITUTIVE_LAW),intent(inout):: self
    integer ite
    real(kind=8)::ts
    real(kind=8)::muk,al,qmx,b,pmax1,pmax2
    pmax1 = min(1.d0,2*ts/(3*self%mat%q2)/abs(self%telh)*acosh(1+(1-self%q1f)**2/(2*self%q1f)))
    if ((1-self%q1f)*ts.lt.self%telq) then
        qmx = ts*(1-self%q1f)/self%telq
        muk = self%mat%troismu/self%mat%troisk
        b   = muk*abs(self%telh)/ts * qmx/(1-qmx) / (0.5d0*self%mat%q2*self%q1f)
        al  = 1.5d0*self%mat%q2*abs(self%telh)/ts
        pmax2  = b/(al+b)
        do ite = 1,3
            pmax2 = pmax2 + (b*(1-pmax2)-sinh(al*pmax2))/(al*cosh(al*pmax2)+b)
        end do
        bnd_pmax = min(pmax1,pmax2)
    else
        bnd_pmax = pmax1
    end if
end function bnd_pmax



end module lcgtn_module
