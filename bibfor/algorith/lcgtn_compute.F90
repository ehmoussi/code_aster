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

function lcgtn_compute(resi,rigi,elas, itemax, prec, m, dt, eps, phi, ep, ka, f, state, &
                  t,deps_t,dphi_t,deps_ka,dphi_ka) &
    result(iret)

    use scalar_newton_module, only: newton_state, utnewt
    use lcgtn_module,         only: gtn_material

    implicit none
#include "asterf_types.h"
#include "asterc/r8prem.h"
#include "asterfort/assert.h"
#include "asterfort/proten.h"

! aslint: disable=W1501,W0104


    aster_logical,intent(in)     :: resi,rigi,elas
    type(gtn_material),intent(in):: m
    integer,intent(in)           :: itemax
    real(kind=8),intent(in)      :: prec
    real(kind=8),intent(in)      :: dt
    real(kind=8),intent(in)      :: eps(:)
    real(kind=8),intent(in)      :: phi
    real(kind=8),intent(inout)   :: ep(:),ka,f
    integer,intent(inout)        :: state
    real(kind=8),intent(out)     :: t(:),deps_t(:,:),dphi_t(:),deps_ka(:),dphi_ka
    integer                      :: iret
! ----------------------------------------------------------------------
!             LOI GTN (LOCAL ET GRADIENT)
! ----------------------------------------------------------------------
! ----------------------------------------------------------------------
    real(kind=8),dimension(6),parameter:: kron = [1.d0,1.d0,1.d0,0.d0,0.d0,0.d0]
! ----------------------------------------------------------------------
    integer     :: i,ite,iteint,iteext
    real(kind=8):: kr(size(eps)),presig,preg,jac,fn,fg,q1f,kam,epmh
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
    iret    = 0
    kr      = kron(1:size(eps))
    jac     = exp(sum(eps(1:3)))
    presig  = min(jac,1.d0)*m%r0*prec
    preg    = prec*1.d-1
    kam     = ka
    epmh    = sum(ep(1:3))/3.d0


!   Porosite de germination et de croissance au debut du pas de temps
    fn = 0.5d0*m%fn*(erf((ka-m%pn)/sqrt(2.d0)/m%sn) + erf(m%pn/sqrt(2.d0)/m%sn))
    fg = f-fn
    
    
!   Calcul de la porosite effective
    if (f.le.m%fc) then
        q1f = m%q1 * f 
    else
        q1f = m%q1*m%fc + (1-m%q1*m%fc)/(m%fr-m%fc)*(f-m%fc)
    end if
    ASSERT(q1f.gt.0 .and. q1f.le.1)


!   Contrainte elastique
    tel  = m%lambda*sum(eps(1:3)-ep(1:3))*kr + m%deuxmu*(eps-ep)
    telh = sum(tel(1:3)) / 3.d0
    teld = tel - telh*kr
    telq = sqrt(1.5d0 * dot_product(teld,teld))


!   Niveau d'ecrouissage
    tsm = f_ts_hat(kam)



! ======================================================================
!               INTEGRATION DE LA LOI DE COMPORTEMENT
! ======================================================================

    if (.not. resi) goto 800



! ----------------------------------------------------------------------
!   CAS D'UN POINT TOTALEMENT ROMPU (q1.f* == 1)
! ----------------------------------------------------------------------

    if ((1-q1f) .le. sqrt(prec)) then
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
    if (1.5d0*m%q2*telh .gt. tsmax*acosh((1+q1f**2)/(2*q1f))) goto 100

!   Borne du critere elastique
    if (f_g(1.d0,1.d0,tsmax).le.0) then
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
    deph  = telh/m%troisk
    depd  = teld/m%deuxmu
    depq  = telq/m%deuxmu
    if (deph**2 + depq**2 .eq. 0) then
      pin = 0
    else
        chim1 = (m%q2*depq)**2 / (9*deph**2/q1f + (m%q2*depq)**2)
        cs    = 2*gamm1*(1-chim1)/(1+sqrt(1+2*gamm1*chim1*(1-chim1)))
        pin   = 2/m%q2*acosh(1+cs)*abs(deph) + 2.d0/3.d0*(1-q1f)*sqrt(1-cs/gamm1)*depq
    end if
    kamin = kam + jac*pin

!   Valeur du critere sur la borne
    tsmin = f_ts_hat(kamin) 
    if (tsmin.gt.presig) goto 200

!   La solution est singuliere : calcul de ka via Ts_hat(ka)==0
    ka = kamin
    do ite = 1,itemax
        equ   = f_ts_hat(ka) 
        d_equ = dka_ts_hat(ka)
        if (abs(equ).le.presig) exit
        ka = utnewt(ka,equ,d_equ,ite,mem)
    end do
    if (ite.gt.itemax) then
        iret = 1
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
    tels = max(telq/(1-q1f),1.5d0*m%q2*telh/acosh(1+0.5d0*(1-q1f)**2/q1f))

    ! Resolution G(Tel,Tel*)=0
    do iteint = 1,itemax
        equ   = f_g(1.d0,1.d0,tels)
        if (abs(equ).le.preg) exit
        d_equ = dts_g(1.d0,1.d0,tels)
        tels = utnewt(tels,-equ,-d_equ,iteint,mem)
    end do
    if (iteint.gt.itemax) then
        iret = 1
        goto 999
    end if        


! 2. Resolution du systeme non lineaire de deux equations

    ! Estimation initiale
    ts = tels

    ! Resolution de M_hat(p(ts),ts) == 0
    do iteext = 1,itemax

        ! 2.1 Resolution de G_hat(p,ts) == 0 par rapport a p
        pmin = bnd_pmin(ts)
        pmax = bnd_pmax(ts)
        p1   = pmax
        do iteint = 1,itemax
            equint   = f_g_hat(p1,ts)
            d_equint = dp_g_hat(p1,ts)
            if (abs(equint).le.prec) exit
            p1 = utnewt(p1,equint,d_equint,iteint,memint,xmin=pmin,xmax=pmax, &
                        usemin=to_aster_logical(pmin.ne.0.d0))
        end do
        if (iteint.gt.itemax) then
            iret = 1
            goto 999
        end if        
        fg1 = equint
        m1  = f_m_hat(p1,ts)
        if (abs(m1).le.presig) then
            p = p1
            exit        
        end if


        ! 2.2 Recherche d'un encadrement de la solution p tel que G_hat(p,ts)=0

        ! Intervalle de recherche
        if (fg1.le.0) then
            offset  = -0.5d0*prec
            xm   = p1
            xp   = pmax
            equm = fg1 + offset
            equp = f_g_hat(pmax,ts) + offset
        else
            offset  =  0.5d0*prec
            xm   = pmin
            xp   = p1
            equm = f_g_hat(pmin,ts) + offset
            equp = fg1 + offset
        end if

        ! Recherche de la seconde borne
        if (equm .ge. -0.1d0*prec) then
            p2 = xm
            fg2 = equm-offset
        else if (equp .le. 0.1d0*prec) then
            p2 = xp
            fg2 = equp-offset
        else
            p2 = p1
            do iteint = 1,itemax
                equint   = f_g_hat(p2,ts)+offset
                d_equint = dp_g_hat(p2,ts)
                if (abs(equint).le.0.1d0*prec) exit
                p2 = utnewt(p2,equint,d_equint,iteint,memint,xmin=xm,xmax=xp, &
                            usemin=to_aster_logical(xm.ne.0.d0))
            end do
            if (iteint.gt.itemax) then
                iret = 1
                goto 999
            end if        
            fg2 = equint-offset
            ASSERT(fg1*fg2 .lt. 0)
        end if

        ! Valeur de p optimale (corde)
        if (equ.ge.0 .or.equp.le.0) then
            p = p2
        else
            p = (p1*fg2 - p2*fg1)/(fg2-fg1)
        end if

        ! Valeur de m sur la seconde borne
        m2  = f_m_hat(p2,ts)
        if (abs(m2).le.presig) then
            p = p2
            exit        
        end if


        ! 2.3 Si l'intervalle (p1,p2) permet de trouver une solution M(p,ts)=0 -> recherche de p
        if (m1*m2.lt.0) then
            ! croissance de M(p,ts) par rapport a p dans l'intervalle (p1,p2)
            sgn = sign(1.d0,p2-p1)*sign(1.d0,m2-m1)

            ! resolution dans l'intervalle
            do iteint = 1,itemax
                equint   = sgn*f_m_hat(p,ts)
                d_equint = sgn*dp_m_hat(p,ts)
                if (abs(equint).le.presig) exit
                p = utnewt(p,equint,d_equint,iteint,memint,xmin=min(p1,p2),xmax=max(p1,p2))
            end do
            if (iteint.gt.itemax) then
                iret = 1
                goto 999
            end if        
            exit
        end if
        

        ! 2.5 Sinon M(p,ts) <> 0 dans l'intervalle (p1,p2) -> nouvel itere pour ts
        equext = f_m_hat(p,ts)
        dts_p  = -dts_g_hat(p,ts)/dp_g_hat(p,ts)
        d_equext = dp_m_hat(p,ts)*dts_p + dts_m_hat(p,ts)
        ts = utnewt(ts,equext,d_equext,iteext,memext,xmin=0.d0,xmax=tels,usemin=ASTER_FALSE)

    end do
    if (iteext.gt.itemax) then
        iret = 1
        goto 999
    end if        


! 3. Actualisation des variables internes et de la contrainte
    q = f_q_hat(p,ts)
    state = 1
    ka    = f_lbd_hat(p,ts) + kam
    deph  = (1-p)*telh/m%troisk
    depd  = (1-q)*teld/m%deuxmu
    ep    = ep + deph*kr + depd
    t     = p*telh*kr + q*teld


    
! ----------------------------------------------------------------------
!   Actualisation de la porosite (sans impact sur les matrices tangentes car q1f inchange)   
! ----------------------------------------------------------------------

500 continue
    deph = sum(ep(1:3))/3.d0-epmh
    fn = 0.5d0*m%fn*(erf((ka-m%pn)/sqrt(2.d0)/m%sn) + erf(m%pn/sqrt(2.d0)/m%sn))
    fg = max(m%f0,fg + 3*deph/(1+3*deph)*(1-fn-fg))
    f  = min(m%fr,fg+fn)





! ======================================================================
!                           MATRICES TANGENTES
! ======================================================================

800 continue
    if (.not.rigi) goto 999

    deps_t  = 0
    dphi_t  = 0
    deps_ka = 0
    dphi_ka = 0


    if (.not. resi) then
        p = 1.d0
        q = 1.d0
        ts = tsm
    end if




    if (state.eq.0 .or. elas) then
        ! Regime elastique (seul deps_t est non nulle, egale a la matrice d'elasticite)
        deps_t(1:3,1:3) = m%lambda
        do i = 1,size(eps)
            deps_t(i,i) = deps_t(i,i) + m%deuxmu
        end do


    else if (state.eq.1) then
        ! Regime plastique regulier

        ! Variations des inconnues principales (p,ts)
        mat(1,1) =  dts_m_hat(p,ts)
        mat(1,2) = -dts_g_hat(p,ts)
        mat(2,1) = -dp_m_hat(p,ts)
        mat(2,2) =  dp_g_hat(p,ts)
        mat      = mat / (mat(1,1)*mat(2,2)-mat(1,2)*mat(2,1))

        vec = -matmul(mat,[dteh_g_hat(p,ts),dteh_m_hat(p,ts)])
        dteh_p  = vec(1)
        dteh_ts = vec(2)
        
        vec = -matmul(mat,[dteq_g_hat(p,ts),dteq_m_hat(p,ts)])
        dteq_p  = vec(1)
        dteq_ts = vec(2)
        
        vec = -matmul(mat,[0.d0,djac_m_hat(p,ts)])
        djac_p  = vec(1)
        djac_ts = vec(2)
        
        vec = -matmul(mat,[0.d0,dphi_m_hat(p,ts)])
        dphi_p  = vec(1)
        dphi_ts = vec(2)
        
        ! Variations de q
        dp_q   = dp_q_hat(p,ts)
        dts_q  = dts_q_hat(p,ts)
        dteh_q = dp_q*dteh_p + dts_q*dteh_ts + dteh_q_hat(p,ts)
        dteq_q = dp_q*dteq_p + dts_q*dteq_ts
        djac_q = dp_q*djac_p + dts_q*djac_ts
        dphi_q = dp_q*dphi_p + dts_q*dphi_ts

        ! Variations de ka
        dp_lbd  = dp_lbd_hat(p,ts)
        dts_lbd = dts_lbd_hat(p,ts)
        dteh_ka = dp_lbd*dteh_p + dts_lbd*dteh_ts + dteh_lbd_hat(p,ts)
        dteq_ka = dp_lbd*dteq_p + dts_lbd*dteq_ts + dteq_lbd_hat(p,ts)
        djac_ka = dp_lbd*djac_p + dts_lbd*djac_ts + djac_lbd_hat(p,ts)
        dphi_ka = dp_lbd*dphi_p + dts_lbd*dphi_ts 
 
        ! Variations des invariants par rapport a epsilon
        deps_teh = m%troisk/3.d0 * kr
        deps_teq = 1.5d0*m%deuxmu*teld/telq
        deps_jac = jac*kr

        ! dt/deps
        lambda_bar = (p*m%troisk - q*m%deuxmu)/3.d0
        deuxmu_bar = q*m%deuxmu
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
        dka_ts  = dka_ts_hat(ka)
        dphi_ka = - dphi_ts_hat(ka)/dka_ts
        djac_ka = - djac_ts_hat(ka)/dka_ts
        deps_ka = djac_ka*deps_jac


    else if (state.eq.3) then
        ! Regime casse -> matrices nulles
        continue

    else
        ASSERT(.false.)
    end if




!    Fin de la routine
999  continue



contains

! ----------------------------------------------------------------------------------------
!  Liste des fonctions intermediaires et leurs derivees
! ----------------------------------------------------------------------------------------

! Variables globales partagees
!     type(gtn_material):: m
!     real(kind=8)      :: jac,telh,telq,q1f,phi
! --> Derivees: djac_*, dteh_*, dteq_*, dphi_*


real(kind=8) function f_g(q,p,ts)
    real(kind=8)::q,p,ts
    f_g = (telq*q/ts)**2 + 2*q1f*cosh(1.5d0*m%q2*telh*p/ts)-1-q1f**2
end function f_g

real(kind=8) function dq_g(q,p,ts)
    real(kind=8)::q,p,ts
    dq_g = 2*telq**2*q/ts**2 
end function dq_g

real(kind=8) function dp_g(q,p,ts)
    real(kind=8)::q,p,ts
    dp_g = 3*q1f*m%q2*telh/ts*sinh(1.5d0*m%q2*telh*p/ts)
end function dp_g

real(kind=8) function dts_g(q,p,ts)
    real(kind=8)::q,p,ts
    dts_g = -2*(telq*q)**2/ts**3 - 3*q1f*m%q2*telh*p/ts**2*sinh(1.5d0*m%q2*telh*p/ts)
end function dts_g

real(kind=8) function dteh_g(q,p,ts)
    real(kind=8)::q,p,ts
    dteh_g = 3*q1f*m%q2*p/ts*sinh(1.5d0*m%q2*telh*p/ts)
end function dteh_g

real(kind=8) function dteq_g(q,p,ts)
    real(kind=8)::q,p,ts
    dteq_g = 2*telq*(q/ts)**2
end function dteq_g



real(kind=8) function f_ecro(ka)
    real(kind=8)::ka
    f_ecro = m%r0+m%rh*ka+m%r1*(1-exp(-m%g1*ka))+m%r2*(1-exp(-m%g2*ka))+m%rk*(ka+m%p0)**m%gk
end function f_ecro

real(kind=8) function dka_ecro(ka)
    real(kind=8)::ka
    dka_ecro = m%rh+m%r1*m%g1*exp(-m%g1*ka)+m%r2*m%g2*exp(-m%g2*ka)+m%rk*m%gk*(ka+m%p0)**(m%gk-1)
end function dka_ecro



real(kind=8) function f_visco(dka)
    real(kind=8)::dka
    real(kind=8)::x,p
    x = abs(dka)/(dt*m%ve0) + m%vd
    p = 1.d0/m%vm
    f_visco = m%vs0*asinh(x**p-m%vd**p)
end function f_visco

real(kind=8) function ddka_visco(dka)
    real(kind=8)::dka
    real(kind=8)::x,p
    x = abs(dka)/(dt*m%ve0) + m%vd
    p = 1.d0/m%vm
    ddka_visco = m%vs0/(dt*m%ve0) * p*x**(p-1)/sqrt(1+(x**p-m%vd**p)**2)
end function ddka_visco



real(kind=8) function f_ts_hat(ka)
    real(kind=8)::ka
    f_ts_hat = jac*(f_ecro(ka) + m%r*ka - phi + f_visco(ka-kam))
end function f_ts_hat

real(kind=8) function dka_ts_hat(ka)
    real(kind=8)::ka
    dka_ts_hat = jac*(dka_ecro(ka) + m%r + ddka_visco(ka-kam))
end function dka_ts_hat

real(kind=8) function djac_ts_hat(ka)
    real(kind=8)::ka
    djac_ts_hat = f_ecro(ka) + m%r*ka - phi + f_visco(ka-kam)
end function djac_ts_hat

real(kind=8) function dphi_ts_hat(ka)
    real(kind=8)::ka
    dphi_ts_hat = -jac
end function dphi_ts_hat



real(kind=8) function f_lambda(x)
    real(kind=8)::x
    f_lambda = 0.5d0*q1f*m%q2*sinh(1.5d0*m%q2*x)
end function f_lambda

real(kind=8) function dx_lambda(x)
    real(kind=8)::x
    dx_lambda = 0.75d0*q1f*m%q2**2*cosh(1.5d0*m%q2*x)
end function dx_lambda



real(kind=8) function f_theta(x,y)
    real(kind=8)::x,y
    f_theta = 1.d0/(y**2 + 3*x*f_lambda(x))
end function f_theta

real(kind=8) function dx_theta(x,y)
    real(kind=8)::x,y
    real(kind=8)::lbd
    lbd = f_lambda(x)
    dx_theta = -3*(lbd + x*dx_lambda(x))/(y**2 + 3*x*lbd)**2
end function dx_theta

real(kind=8) function dy_theta(x,y)
    real(kind=8)::x,y
    dy_theta = -(2*y)/(y**2 + 3*x*f_lambda(x))**2
end function dy_theta



real(kind=8) function f_q_hat(p,ts)
    real(kind=8)::p,ts
    real(kind=8)::muk,num,den
    muk = 1.5d0*m%deuxmu/m%troisk
    num = ts*f_lambda(telh*p/ts)
    den = num + muk*telh*(1-p)
    f_q_hat = num/den
end function f_q_hat

real(kind=8) function dp_q_hat(p,ts)
    real(kind=8)::p,ts
    real(kind=8)::muk,num,den,d_num,d_den
    muk = 1.5d0*m%deuxmu/m%troisk
    num = ts*f_lambda(telh*p/ts)
    den = num + muk*telh*(1-p)
    d_num = dx_lambda(telh*p/ts)*telh
    d_den = d_num - muk*telh
    dp_q_hat = (d_num*den-num*d_den)/den**2
end function dp_q_hat

real(kind=8) function dts_q_hat(p,ts)
    real(kind=8)::p,ts
    real(kind=8)::muk,num,den,lbd,d_num,d_den
    muk = 1.5d0*m%deuxmu/m%troisk
    lbd = f_lambda(telh*p/ts)
    num = ts*lbd
    den = num + muk*telh*(1-p)
    d_num = lbd - dx_lambda(telh*p/ts)*(telh*p/ts)
    d_den = d_num 
    dts_q_hat = (d_num*den-num*d_den)/den**2
end function dts_q_hat

real(kind=8) function dteh_q_hat(p,ts)
    real(kind=8)::p,ts
    real(kind=8)::muk,w,num,d_num,den,d_den,lbd0,a0p,seuil
    muk = 1.5d0*m%deuxmu/m%troisk
    w   = 1.5d0*m%q2*telh*p/ts
    seuil = (r8prem()*1200)**0.25d0
    if (abs(w).le.seuil) then
        ! Precision numerique quand telh petit (dvp limite de lambda ordre 4)
        lbd0 = 0.5d0*q1f*m%q2
        a0p  = 1.5d0*m%q2*p
        dteh_q_hat = (12*(a0p)**3*lbd0*muk*(1-p)*ts**2*telh) & 
                   / (lbd0*a0p*(6*ts**2+(a0p*telh)**2) + 6*muk*ts**2*(1-p))**2
    else
        ! Derivee normale de lambda avec le sinh
        num = ts*f_lambda(telh*p/ts)
        d_num = dx_lambda(telh*p/ts)*p
        den = num + muk*telh*(1-p)
        d_den = d_num + muk*(1-p)
        dteh_q_hat = (d_num*den-num*d_den)/den**2
    end if
end function dteh_q_hat



real(kind=8) function f_g_hat(p,ts)
    real(kind=8)::p,ts
    real(kind=8)::q
    q = f_q_hat(p,ts)
    f_g_hat = f_g(q,p,ts)
end function f_g_hat

real(kind=8) function dp_g_hat(p,ts)
    real(kind=8)::p,ts
    real(kind=8)::q
    q = f_q_hat(p,ts)
    dp_g_hat = dq_g(q,p,ts)*dp_q_hat(p,ts) + dp_g(q,p,ts)
end function dp_g_hat

real(kind=8) function dts_g_hat(p,ts)
    real(kind=8)::p,ts
    real(kind=8)::q
    q = f_q_hat(p,ts)
    dts_g_hat = dq_g(q,p,ts)*dts_q_hat(p,ts) + dts_g(q,p,ts)
end function dts_g_hat

real(kind=8) function dteh_g_hat(p,ts)
    real(kind=8)::p,ts
    real(kind=8)::q,d_q
    q = f_q_hat(p,ts)
    d_q = dteh_q_hat(p,ts)
    dteh_g_hat = dq_g(q,p,ts)*d_q + dteh_g(q,p,ts)
end function dteh_g_hat

real(kind=8) function dteq_g_hat(p,ts)
    real(kind=8)::p,ts
    real(kind=8)::q
    q = f_q_hat(p,ts)
    dteq_g_hat = dteq_g(q,p,ts)
end function dteq_g_hat



real(kind=8) function f_lbd_hat(p,ts)
    real(kind=8)::p,ts
    real(kind=8)::jk,q,num,den,lbd,the
    jk = jac/m%troisk
    q  = f_q_hat(p,ts)
    lbd = f_lambda(telh*p/ts)
    the = f_theta(telh*p/ts,telq*q/ts)
    num = jk*telh*(1-p)
    den = the*lbd
    f_lbd_hat = num/den
end function f_lbd_hat

real(kind=8) function dp_lbd_hat(p,ts)
    real(kind=8)::p,ts
    real(kind=8)::jk,q,d_q,lbd,d_lbd,the,d_the,num,d_num,den,d_den
    jk = jac/m%troisk
    q = f_q_hat(p,ts)
    d_q = dp_q_hat(p,ts)
    lbd = f_lambda(telh*p/ts)
    d_lbd = dx_lambda(telh*p/ts)*telh/ts
    the = f_theta(telh*p/ts,telq*q/ts)
    d_the = dx_theta(telh*p/ts,telq*q/ts)*telh/ts + dy_theta(telh*p/ts,telq*q/ts)*telq/ts*d_q
    num = jk*telh*(1-p)
    d_num = -jk*telh
    den = the*lbd
    d_den = d_the*lbd + the*d_lbd
    dp_lbd_hat = (d_num*den-num*d_den)/den**2
end function dp_lbd_hat

real(kind=8) function dts_lbd_hat(p,ts)
    real(kind=8)::p,ts
    real(kind=8)::jk,q,d_q,lbd,d_lbd,the,d_the,num,den,d_den
    jk = jac/m%troisk
    q = f_q_hat(p,ts)
    d_q = dts_q_hat(p,ts)
    lbd = f_lambda(telh*p/ts)
    d_lbd = dx_lambda(telh*p/ts)*(-telh*p/ts**2)
    the = f_theta(telh*p/ts,telq*q/ts)
    d_the = dx_theta(telh*p/ts,telq*q/ts)*(-telh*p/ts**2) &
          + dy_theta(telh*p/ts,telq*q/ts)*telq*(d_q*ts-q)/ts**2
    num = jk*telh*(1-p)
    den = the*lbd
    d_den = d_the*lbd + the*d_lbd
    dts_lbd_hat = -num*d_den/den**2
end function dts_lbd_hat

real(kind=8) function djac_lbd_hat(p,ts)
    real(kind=8)::p,ts
    real(kind=8)::jk,d_jk,q,num,d_num,den,lbd,the
    jk = jac/m%troisk
    d_jk = 1/m%troisk
    q  = f_q_hat(p,ts)
    lbd = f_lambda(telh*p/ts)
    the = f_theta(telh*p/ts,telq*q/ts)
    num = jk*telh*(1-p)
    d_num = d_jk*telh*(1-p)
    den = the*lbd
    djac_lbd_hat = d_num/den
end function djac_lbd_hat

real(kind=8) function dteh_lbd_hat(p,ts)
    real(kind=8)::p,ts
    real(kind=8)::jk,q,d_q,num,d_num,den,d_den,lbd,d_lbd,the,d_the
    jk = jac/m%troisk
    q = f_q_hat(p,ts)
    d_q = dteh_q_hat(p,ts)
    lbd = f_lambda(telh*p/ts)
    d_lbd = dx_lambda(telh*p/ts)*p/ts
    the = f_theta(telh*p/ts,telq*q/ts)
    d_the = dx_theta(telh*p/ts,telq*q/ts)*p/ts + dy_theta(telh*p/ts,telq*q/ts)*telq*d_q/ts
    num = jk*telh*(1-p)
    d_num = jk*(1-p)
    den = the*lbd
    d_den = d_the*lbd + the*d_lbd
    dteh_lbd_hat = (d_num*den - num*d_den)/den**2
end function dteh_lbd_hat

real(kind=8) function dteq_lbd_hat(p,ts)
    real(kind=8)::p,ts
    real(kind=8)::jk,q,num,den,d_den,lbd,the,d_the
    jk = jac/m%troisk
    q  = f_q_hat(p,ts)
    lbd = f_lambda(telh*p/ts)
    the = f_theta(telh*p/ts,telq*q/ts)
    d_the = dy_theta(telh*p/ts,telq*q/ts)*q/ts
    num = jk*telh*(1-p)
    den = the*lbd
    d_den = d_the*lbd
    dteq_lbd_hat = -num*d_den/den**2
end function dteq_lbd_hat



real(kind=8) function f_m_hat(p,ts)
    real(kind=8)::p,ts
    f_m_hat = ts - f_ts_hat(f_lbd_hat(p,ts)+kam)
end function f_m_hat

real(kind=8) function dp_m_hat(p,ts)
    real(kind=8)::p,ts
    dp_m_hat = -dka_ts_hat(f_lbd_hat(p,ts)+kam)*dp_lbd_hat(p,ts)
end function dp_m_hat

real(kind=8) function dts_m_hat(p,ts)
    real(kind=8)::p,ts
    dts_m_hat = 1 - dka_ts_hat(f_lbd_hat(p,ts)+kam)*dts_lbd_hat(p,ts)
end function dts_m_hat

real(kind=8) function djac_m_hat(p,ts)
    real(kind=8)::p,ts
    real(kind=8)::lbd,d_lbd
    lbd = f_lbd_hat(p,ts)
    d_lbd = djac_lbd_hat(p,ts)
    djac_m_hat = - djac_ts_hat(lbd+kam) - dka_ts_hat(lbd+kam)*d_lbd
end function djac_m_hat

real(kind=8) function dphi_m_hat(p,ts)
    real(kind=8)::p,ts
    real(kind=8)::lbd
    lbd = f_lbd_hat(p,ts)
    dphi_m_hat = -dphi_ts_hat(lbd+kam)
end function dphi_m_hat

real(kind=8) function dteh_m_hat(p,ts)
    real(kind=8)::p,ts
    real(kind=8)::lbd,d_lbd
    lbd = f_lbd_hat(p,ts)
    d_lbd = dteh_lbd_hat(p,ts)
    dteh_m_hat = -dka_ts_hat(lbd+kam)*d_lbd
end function dteh_m_hat

real(kind=8) function dteq_m_hat(p,ts)
    real(kind=8)::p,ts
    real(kind=8)::lbd,d_lbd
    lbd = f_lbd_hat(p,ts)
    d_lbd = dteq_lbd_hat(p,ts)
    dteq_m_hat = -dka_ts_hat(lbd+kam)*d_lbd
end function dteq_m_hat




real(kind=8) function bnd_pmin(ts)
    real(kind=8)::ts
    real(kind=8)::chm
    if (telq.ge.ts*(1-q1f)) then
        bnd_pmin = 0.d0
    else
        chm = abs((1-q1f)**2 - (telq/ts)**2)/(2*q1f)
        bnd_pmin = ts/abs(telh)*2/(3*m%q2)*acosh(chm+1)
    end if
end function bnd_pmin


real(kind=8) function bnd_pmax(ts)
    real(kind=8)::ts
    real(kind=8)::muk,al,qmx,b,pmax1,pmax2
    pmax1 = min(1.d0,2*ts/(3*m%q2)*acosh(1+(1-q1f)**2/(2*q1f)))
    if ((1-q1f)*ts.lt.telq) then
        qmx = ts*(1-q1f)/telq
        muk = 1.5d0*m%deuxmu/m%troisk
        b   = muk*abs(telh)/ts * qmx/(1-qmx) / (0.5d0*m%q2*q1f)
        al  = 1.5d0*m%q2*abs(telh)/ts
        pmax2  = b/(al+b)
        do ite = 1,3
            pmax2 = pmax2 + (b*(1-pmax2)-sinh(al*pmax2))/(al*cosh(al*pmax2)+b)
        end do
        bnd_pmax = min(pmax1,pmax2)
    else
        bnd_pmax = pmax1
    end if
end function bnd_pmax


end function

