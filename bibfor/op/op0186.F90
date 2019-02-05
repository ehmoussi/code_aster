! --------------------------------------------------------------------
! Copyright (C) 1991 - 2019 - EDF R&D - www.code-aster.org
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
! person_in_charge: mickael.abbas at edf.fr
!
subroutine op0186()
!
use NonLin_Datastructure_type
use Rom_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterc/etausr.h"
#include "asterc/getres.h"
#include "asterfort/gettco.h"
#include "asterc/r8vide.h"
#include "asterfort/assert.h"
#include "asterfort/copisd.h"
#include "asterfort/detmat.h"
#include "asterfort/didern.h"
#include "asterfort/diinst.h"
#include "asterfort/dismoi.h"
#include "asterfort/nonlinDSColumnWriteValue.h"
#include "asterfort/infmaj.h"
#include "asterfort/infniv.h"
#include "asterfort/jedema.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/medith.h"
#include "asterfort/nmnkft.h"
#include "asterfort/nmlere.h"
#include "asterfort/ntdata.h"
#include "asterfort/ntarch.h"
#include "asterfort/ntobsv.h"
#include "asterfort/nxini0.h"
#include "asterfort/nxacmv.h"
#include "asterfort/nxinit.h"
#include "asterfort/nxlect.h"
#include "asterfort/nxnewt.h"
#include "asterfort/nxpred.h"
#include "asterfort/nxrech.h"
#include "asterfort/romAlgoNLClean.h"
#include "asterfort/rsinch.h"
#include "asterfort/sigusr.h"
#include "asterfort/titre.h"
#include "asterfort/utmess.h"
#include "asterfort/uttcpr.h"
#include "asterfort/uttcpu.h"
#include "asterfort/vtcreb.h"
#include "asterfort/vtzero.h"
#include "asterfort/setTimeListProgressBar.h"
#include "asterfort/nxnpas.h"
#include "asterfort/nmimr0.h"
#include "asterfort/nmimck.h"
#include "asterfort/nmimci.h"
#include "asterfort/nmimcr.h"
#include "asterfort/nmimpr.h"
#include "asterfort/nmimpx.h"
!
! --------------------------------------------------------------------------------------------------
!
! THER_NON_LINE
!
! --------------------------------------------------------------------------------------------------
!
    aster_logical :: l_stat, matcst, coecst, reasma, arret, conver, itemax
    aster_logical :: l_dry, l_line_search, finpas, l_evol, lnkry
    aster_logical :: force, l_rom
    integer :: ther_crit_i(3), nume_inst, k, iterho
    integer :: itmax, ifm, niv, neq, iter_newt, jtempp, jtemp
    integer :: itab(2)
    real(kind=8) :: tpsthe(6), deltat, tps1(7)
    real(kind=8) :: tps2(4), tps3(4), tpex, ther_crit_r(2), rho
    real(kind=8) :: para(2), time_curr, tconso
    real(kind=8) :: rtab(2), theta_read
    character(len=8) :: result, result_dry, mesh
    character(len=19) :: sdobse
    character(len=19) :: solver, maprec, sddisc, sdcrit, varc_curr, list_load
    character(len=24) :: model, mate, cara_elem
    character(len=24) :: time, dry_prev, dry_curr, compor, vtemp, vtempm, vtempp
    character(len=24) :: vtempr, cn2mbr_stat, cn2mbr_tran, nume_dof, mediri, matass, cndiri, cn2mbr
    character(len=24) :: cncine, cnresi, vabtla, vhydr, vhydrp
    character(len=24) :: tpscvt
    real(kind=8), pointer :: v_crit_crtr(:) => null()
    real(kind=8), pointer :: tempm(:) => null()
!
    type(NL_DS_InOut)     :: ds_inout
    type(NL_DS_AlgoPara)  :: ds_algopara
    type(ROM_DS_AlgoPara) :: ds_algorom
    type(NL_DS_Print)     :: ds_print
!
    data sdcrit/'&&OP0186.CRITERE'/
    data maprec/'&&OP0186.MAPREC'/
    data cndiri/1*' '/
    data cncine/1*' '/
    data cn2mbr_stat/'&&OP0186.2ND'/
    data cn2mbr_tran/'&&OP0186.2NI'/
    data cn2mbr/'&&OP0186.2MBRE'/
    data dry_prev,dry_curr/'&&OP0186.TCHI','&&OP0186.TCHF'/
    data vhydr,vhydrp/'&&OP0186.HY','&&OP0186.HYP'/
    data mediri/'&&MEDIRI'/
    data matass/'&&MTHASS'/
    data sddisc            /'&&OP0186.PARTPS'/
!
! --------------------------------------------------------------------------------------------------
!
    call jemarq()
    call infmaj()
    call infniv(ifm, niv)
!
! - Initializations
!
    solver    = '&&OP0186.SOLVER'
    list_load = '&&OP0186.LISCHA'
    varc_curr = '&&OP0186.CHVARC'
! --- CE BOOLEEN ARRET EST DESTINE AUX DEVELOPPEURS QUI VOUDRAIENT
! --- FORCER LE CALCUL MEME SI ON N'A PAS CONVERGENCE (ARRET=TRUE)
    arret     = ASTER_FALSE
!
! - Creation of datastructures
!
    call nxini0(ds_algopara, ds_inout, ds_print)
!
! - Read parameters (linear)
!
    call ntdata(list_load, solver, matcst   , coecst  , result    ,&
                model    , mate  , cara_elem, ds_inout, theta_read)
    para(1)    = theta_read
!
! - Read parameters (non-linear)
!
    call nxlect(result     , model      ,&
                ther_crit_i, ther_crit_r,&
                ds_inout   , ds_algopara,&
                ds_algorom , ds_print   ,&
                result_dry , compor     ,&
                mesh       , l_dry)
    itmax      = ther_crit_i(3)
!
! - Initializations
!
    call nxinit(mesh         , model   , mate       ,&
                cara_elem    , compor  , list_load  ,&
                para         , nume_dof,&
                sddisc       , ds_inout, sdobse     ,&
                sdcrit       , time    , ds_algopara,&
                ds_algorom   , ds_print, vhydr      ,&
                l_stat       , l_evol  , l_rom      ,&
                l_line_search, lnkry)
!
    if (l_stat) then
        nume_inst=0
    else
        nume_inst=1
    endif
    deltat=-1.d150
!
! --- CREATION DES OBJETS DE TRAVAIL ET DES STRUCTURES DE DONNEES
    vtemp ='&&NXLECTVAR_____'
    vtempp='&&NXLECTVAR_T_MO'
    vtempm='&&NXLECTVAR_T_PL'
    vtempr='&&NXLECTVAR_INIT'


    if (l_stat) then
        call vtcreb(vtempm, 'V', 'R', nume_ddlz = nume_dof)
        call vtcreb(vtempp, 'V', 'R', nume_ddlz = nume_dof)
        call vtcreb(vtempr, 'V', 'R', nume_ddlz = nume_dof)
        call vtcreb(cn2mbr_stat, 'V', 'R', nume_ddlz = nume_dof)
        call vtcreb(cn2mbr_tran, 'V', 'R', nume_ddlz = nume_dof)
    else
        call copisd('CHAMP_GD', 'V', vtemp, vtempm)
        call copisd('CHAMP_GD', 'V', vtemp, vtempp)
        call copisd('CHAMP_GD', 'V', vtemp, vtempr)
        call copisd('CHAMP_GD', 'V', vtemp, cn2mbr_stat)
        call copisd('CHAMP_GD', 'V', vtemp, cn2mbr_tran)
    endif
    call jelira(vtempm(1:19)//'.VALE', 'LONMAX', neq)
    call copisd('CHAMP_GD', 'V', vhydr, vhydrp)
!
! - Total second member
!
    call copisd('CHAMP_GD', 'V', vtemp, cn2mbr)
!
! - Elementary matrix for Dirichlet BC
!
    call medith('V', 'ZERO', model, list_load, mediri)
!
    call uttcpu('CPU.OP0186.1', 'INIT', ' ')
    call uttcpr('CPU.OP0186.1', 7, tps1)
    tpex = tps1(7)
    call uttcpu('CPU.OP0186.2', 'INIT', ' ')
    call uttcpu('CPU.OP0186.3', 'INIT', ' ')
    call uttcpr('CPU.OP0186.3', 4, tps3)
!
! **********************************************************************
!
! Loop on time steps
!
! **********************************************************************
!
!
200 continue
!
! - Launch timer for current step time
!
    call uttcpu('CPU.OP0186.1', 'DEBUT', ' ')
!
! - Reset values in convergence table for Newton loop
!
    call nmimr0(ds_print, 'NEWT')
!
! - Updates for new time step
!
    call nxnpas(sddisc, solver    , nume_inst, ds_print,&
                lnkry , l_evol    , l_stat   ,&
                l_dry , result_dry, dry_prev , dry_curr,&
                para  , time_curr , deltat   , reasma  ,&
                tpsthe)
!
! - Compute second members and tangent matrix
!
    call nxacmv(model      , mate     , cara_elem , list_load, nume_dof   ,&
                solver     , l_stat   , time      , tpsthe   , vtemp      ,&
                vhydr      , varc_curr, dry_prev  , dry_curr , cn2mbr_stat,&
                cn2mbr_tran, matass   , maprec    , cndiri   , cncine     ,&
                mediri     , compor   , ds_algorom)
!
! ======================================================================
!                        PHASE DE PREDICTION
! ======================================================================
! SECONDS MEMBRES ASSEMBLES B
! EN STATIONNAIRE: |VEC2ND - RESI_THER - (BT)*LAGRANGE|
!                  | DIRICHLET - B*TEMPERATURE INIT   |
! EN TRANSITOIRE : |            VEC2NI                |
!                  |           DIRICHLET              |
!
    call nxpred(model     , mate  , cara_elem, list_load  , nume_dof   ,&
                solver    , l_stat, tpsthe   , time       , matass     ,&
                neq       , maprec, varc_curr, vtemp      , vtempm     ,&
                cn2mbr    , vhydr , vhydrp   , dry_prev   , dry_curr   ,&
                compor    , cndiri, cncine   , cn2mbr_stat, cn2mbr_tran,&
                ds_algorom)
!
    iter_newt = 0
    itemax = ASTER_FALSE
    conver = ASTER_FALSE
!
! ======================================================================
!     BOUCLE SUR LES ITERATIONS DE NEWTON
! ======================================================================
!
 20 continue
!
! --- DOIT ON REACTUALISER LA MATRICE TANGENTE
!
    call uttcpu('CPU.OP0186.2', 'DEBUT', ' ')
    iter_newt = iter_newt + 1
    reasma = .false.
    if (iter_newt .ge. itmax) then
        itemax = .true.
    endif
    if ((ds_algopara%reac_iter.ne.0)) then
        if (mod(iter_newt,ds_algopara%reac_iter) .eq. 0) then
            reasma = .true.
        endif
    endif
!
    call nmimck(ds_print, 'MATR_ASSE', ' ', ASTER_FALSE)
    if (reasma) then
        call nmimck(ds_print, 'MATR_ASSE', '      OUI', ASTER_TRUE)
    endif
!
! ON ASSEMBLE LE SECOND MEMBRE B= |VEC2ND - RESI_THER - (BT)*LAGRANGE|
!                                 |             0                    |
! SYSTEME LINEAIRE RESOLU:  A * (T+,I+1 - T+,I) = B
! SOLUTION: VTEMPP = T+,I+1 - T+,I
!
    call nxnewt(model   , mate       , cara_elem  , list_load, nume_dof  ,&
                solver  , tpsthe     , time       , matass   , cn2mbr    ,&
                maprec  , cncine     , varc_curr  , vtemp    , vtempm    ,&
                vtempp  , cn2mbr_stat, mediri     , conver   , vhydr     ,&
                vhydrp  , dry_prev   , dry_curr   , compor   , vabtla    ,&
                cnresi  , ther_crit_i, ther_crit_r, reasma   , ds_algorom,&
                ds_print, sddisc     , iter_newt)
!
! --- SI NON CONVERGENCE ALORS RECHERCHE LINEAIRE
!       (CALCUL DE RHO) SUR L INCREMENT VTEMPP
! --- ACTUALISATION DE LA TEMPERATURE VTEMPM AVEC L INCREMENT VTEMPP
!     MULTIPLIE PAR RHO
    rho    = 0.d0
    iterho = 0
    call nmimr0(ds_print, 'RELI')
    if (.not.conver) then
        if (l_line_search) then
            call nxrech(model , mate    , cara_elem, list_load  , nume_dof ,&
                        tpsthe, time    , neq      , compor     , varc_curr,&
                        vtempm, vtempp  , vtempr   , vtemp      , vhydr    ,&
                        vhydrp, dry_prev, dry_curr , cn2mbr_stat, vabtla   ,&
                        cnresi, rho     , iterho   , ds_algopara)
            call nmimci(ds_print, 'RELI_NBIT', iterho, l_affe = ASTER_TRUE)
            call nmimcr(ds_print, 'RELI_COEF', rho   , l_affe = ASTER_TRUE)
        else
            rho = 1.d0
        endif
        call jeveuo(vtempp(1:19)//'.VALE', 'L', jtempp)
        call jeveuo(vtempm(1:19)//'.VALE', 'E', vr=tempm)
!
! SOLUTION: VTEMPM = VTEMPR = T+,I+1BIS
        do k = 1, neq
            tempm(k) = tempm(k) + rho*zr(jtempp+k-1)
        end do
    endif
!
! - End of time measure for Newton
!
    call uttcpu('CPU.OP0186.2', 'FIN', ' ')
    call uttcpr('CPU.OP0186.2', 4, tps2)
    call nmimcr(ds_print, 'ITER_TIME', tps2(4), ASTER_TRUE)
!
! - Print line in convergence table
!
    call nmimpr(ds_print)
!
! - Print separator line in convergence table
!
    if (conver) then
        if (ds_print%l_print) then 
            call nmimpx(ds_print)
        endif
    endif
!
    if (itemax .and. .not.conver) then
        call utmess('I', 'MECANONLINE10_3')
    endif
!
! - Update NEWTON-KRYLOV (FORCING-TERM)
!
    if (lnkry) then
       call nmnkft(solver, sddisc, iter_newt)
    endif
!
    if ((.not.conver) .and. (.not.itemax)) then
        if (2.d0*tps2(4) .gt. 0.95d0*tps2(1)-tps3(4)) then
            itab(1) = nume_inst
            rtab(1) = tps2(4)
            rtab(2) = tps2(1)
            call utmess('Z', 'DISCRETISATION2_79', si=itab(1), nr=2, valr=rtab, num_except=28)
        else
            goto 20
        endif
    else if ((.not.conver) .and. itemax .and. (.not.arret)) then
        itab(1) = nume_inst
        itab(2) = iter_newt
        call utmess('Z', 'THERNONLINE4_85', ni=2, vali=itab, num_except=22)
    endif
!
! --- VERIFICATION SI INTERRUPTION DEMANDEE PAR SIGNAL USR1
!
    if (etausr() .eq. 1) then
        call sigusr()
    endif
!
! ======================================================================
!                   ACTUALISATIONS ET ARCHIVAGE
! ======================================================================
!
    call uttcpu('CPU.OP0186.3', 'DEBUT', ' ')
    call copisd('CHAMP_GD', 'V', vhydrp(1:19), vhydr(1:19))
!
! ======================================================================
! -- PREPARATION DES PARAMETRES ARCHIVES  ------------------------------
! ======================================================================
    if (conver) then
        call jeveuo(sdcrit(1:19)//'.CRTR', 'E', vr=v_crit_crtr)
        v_crit_crtr(1) = iter_newt
    endif
!
    finpas = didern(sddisc, nume_inst)
!
    call jeveuo(vtempm(1:19)//'.VALE', 'L', jtempp)
    call jeveuo(vtemp(1:19)//'.VALE', 'E', jtemp)
! VTEMPM --> VTEMP
    do k = 1, neq
        zr(jtemp+k-1) = zr(jtempp+k-1)
    end do
    call uttcpu('CPU.OP0186.3', 'FIN', ' ')
    call uttcpr('CPU.OP0186.3', 4, tps3)
!
! - TRANSFORMATION DE PHASE CALCUL HR
!
    if (ds_algorom%l_hrom_corref) then
        if (ds_algorom%phase .eq. 'HROM') then
            ds_algorom%phase = 'CORR_EF'
            go to 20
        else if (ds_algorom%phase .eq. 'CORR_EF') then
            ds_algorom%phase = 'HROM'
        endif
    endif
!
! ------- ARCHIVAGE
!
    if (.not.l_evol) then
        force = .true.
    else
        force = .false.
    endif
    call ntarch(nume_inst, model   , mate , cara_elem, para,&
                sddisc   , ds_inout, force, sdcrit   , ds_algorom)
!
! - Make observation
!
    if (l_evol) then
        call ntobsv(mesh, sdobse, nume_inst, time_curr)
    endif
!
! ------- VERIFICATION SI INTERRUPTION DEMANDEE PAR SIGNAL USR1
!
    if (etausr() .eq. 1) then
        call sigusr()
    endif
!
! ------- TEMPS DISPONIBLE POUR CONTINUER ?
!
    call uttcpu('CPU.OP0186.1', 'FIN', ' ')
    call uttcpr('CPU.OP0186.1', 7, tps1)
    tconso = tps1(7) - tpex
    call nonlinDSColumnWriteValue(0, time_=tconso, output_string_=tpscvt)
    call utmess('I', 'MECANONLINE7_1', sk=tpscvt)
    write (ifm,'(/)')
    tpex = tps1(7)
    if (tps1(4) .gt. 0.48d0*tps1(1)) then
        itab(1) = nume_inst
        rtab(1) = tps2(4)
        rtab(2) = tps2(1)
        call utmess('Z', 'DISCRETISATION2_80', si=itab(1), nr=2, valr=rtab,&
                    num_except=28)
    endif
!
    if (finpas) then
        if (l_evol) then
            call setTimeListProgressBar(sddisc, nume_inst, final_ = ASTER_TRUE)
        endif
        goto 500
    endif
!
!----- NOUVEAU PAS DE TEMPS
    nume_inst = nume_inst + 1
    if (.not.l_stat) then
        call setTimeListProgressBar(sddisc, nume_inst)
    endif
    if (l_stat) then
        l_stat=.false.
    endif
    goto 200
!
500 continue
!
    call titre()
!
! --- DESTRUCTION DE TOUTES LES MATRICES CREEES
!
    call detmat()
!
    if (ds_algorom%l_rom) then
        call romAlgoNLClean(ds_algorom)
    endif
!
    call jedema()
!
end subroutine
