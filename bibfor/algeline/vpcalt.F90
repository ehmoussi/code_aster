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

subroutine vpcalt(eigsol, vecrer, vecrei, vecrek, vecvp,&
                  matopa, matpsc, mxresf, nblagr, nstoc,&
                  omemax, omemin, omeshi, solveu, vecblo,&
                  veclag, vecrig, sigma, npivot, flage,&
                  nconv, vpinf, vpmax)
!
! ROUTINE EFFECTUANT LE CALCUL MODAL PARAMETRE DANS EIGSOL PAR LA METHODE DE LANCZOS.
! RQ. ON DETRUIT L'OBJET VECRIG SI NECESSAIRE.
! -------------------------------------------------------------------------------------------------
! person_in_charge: olivier.boiteau at edf.fr
    implicit none
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterc/r8depi.h"
#include "asterfort/assert.h"
#include "asterfort/freqom.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jeexin.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/rectfr.h"
#include "asterfort/utmess.h"
#include "asterfort/vpbost.h"
#include "asterfort/vpecri.h"
#include "asterfort/vpordi.h"
#include "asterfort/vpordo.h"
#include "asterfort/vplecs.h"
#include "asterfort/vpreco.h"
#include "asterfort/vp2ini.h"
#include "asterfort/vp2trd.h"
#include "asterfort/wkvect.h"
#include "asterfort/wp2ini.h"
#include "asterfort/wp2vec.h"
!
! --- INPUT
!
    integer, intent(in) :: mxresf, nblagr, nstoc
    real(kind=8), intent(in) :: omemax, omemin, omeshi
    complex(kind=8), intent(in) :: sigma
    character(len=19), intent(in) :: eigsol, matopa, matpsc, solveu, vecrig
    character(len=24), intent(in) :: vecrer, vecrei, vecrek, vecvp, vecblo, veclag
!
! --- OUTPUT
!
    integer, intent(out) :: nconv
    real(kind=8), intent(out) :: vpinf, vpmax
    aster_logical , intent(out) :: flage
!
! --- INPUT/OUTPUT
!
    integer, intent(inout) :: npivot
!
! --- VARIABLES LOCALES
!
    integer :: i, iret, imet, lamor, lmasse, lmatra, lraide, nbvect, neq, nfreq
    integer :: lselec, ldiagr, lsurdr, lprod, lddl, lsign, lxrig, lmtpsc
    integer :: iadx, iady, iadz, iadrh, iadrb
    integer :: mfreq, ifreq, nitv, nborto, nitqrm
    integer :: lresui, lresur, lresuk, lvec
    real(kind=8) :: quapi2, omecor, precdc, rbid, rzero, prorto, prsudg
    character(len=1) :: appr
    character(len=8) :: method
    character(len=16) :: optiof, typres
    character(len=19) :: amor, masse, raide
    character(len=24) :: kmetho, k24bid
    aster_logical :: lc, lkr, lns, lpg
!
! -----------------------
! --- CORPS DE LA ROUTINE
! -----------------------
!
!
! ---  INITS.
!
    call jemarq()
    quapi2=r8depi()*r8depi()
    rzero=0.d0
    kmetho='LANCZOS'
!
    nconv=0
    flage=.false.
    call jeveuo(vecrer, 'E', lresur)
    call jeveuo(vecrei, 'E', lresui)
    call jeveuo(vecrek, 'E', lresuk)
    call jeveuo(vecvp, 'E', lvec)
    call jeveuo(vecblo, 'L', lprod)
    call jeveuo(veclag, 'L', lddl)
    if (nstoc .ne. 0) then
        call jeveuo(vecrig, 'L', lxrig)
    else
        lxrig=0
    endif
!
! --- LECTURE DES DONNEES DE EIGSOL
!
    call vplecs(eigsol, nitv_=nitv,&
                nborto_=nborto, nbvect_=nbvect, nfreq_=nfreq,&
                omecor_=omecor,&
                precdc_=precdc, prorto_=prorto, prsudg_=prsudg,&
                appr_=appr, method_=method, optiof_=optiof,&
                typres_=typres, amor_=amor, masse_=masse, raide_=raide,&
                lc_=lc, lkr_=lkr, lns_=lns, lpg_=lpg)
    ASSERT(method(1:8).eq.'TRI_DIAG')
!
! ---  DESCRIPTEURS MATRICES
    call jeveuo(raide//'.&INT', 'E', lraide)
    neq = zi(lraide+2)
    call jeveuo(masse//'.&INT', 'E', lmasse)
    if (lc) then
        call jeveuo(amor//'.&INT', 'E', lamor)
    else
        lamor=0
    endif
    call jeveuo(matopa//'.&INT', 'E', lmatra)
    call jeexin(matpsc//'.&INT', iret)
    if (iret .eq. 0) then
        lmtpsc=0
    else
        call jeveuo(matpsc//'.&INT', 'E', lmtpsc)
    endif
!
! --- PRE-ALLOCATIONS MEMOIRE
!
    call wkvect('&&VPCALT.SELECT', 'V V L', nbvect, lselec)
    call wkvect('&&VPCALT.MAT.DIAG', 'V V R', nbvect, ldiagr)
    call wkvect('&&VPCALT.MAT.SUR.DIAG', 'V V R', nbvect, lsurdr)
    call wkvect('&&VPCALT.SIGNES', 'V V R', nbvect, lsign)
!     ------------------------------------------------------------------
!     -------  LANCZOS PB GENERALISE REEL SYMETRIQUE -------------------
!     ------------------------------------------------------------------
    if ((.not.lkr) .or. lns) then
        ASSERT(.false.)
    endif
    if (.not.lc) then
        call wkvect('&&VPCALT.MAT.MOD.REDUITE', 'V V R', nbvect* nbvect, iadz)
!     ------------------------------------------------------------------
!     -------  LANCZOS PB QUADRATIQUE REEL SYMETRIQUE ------------------
!     ------------------------------------------------------------------
    else
        call wkvect('&&VPCALT.VECT.LANCZOS', 'V V R', neq*nbvect, iadx)
        call wkvect('&&VPCALT.VECTY   ', 'V V R', neq*nbvect, iady)
        call wkvect('&&VPCALT.MAT.MOD.REDUITE', 'V V R', 2*nbvect* nbvect, iadz)
        call wkvect('&&VPCALT.VECT_DEP.H', 'V V R', neq, iadrh)
        call wkvect('&&VPCALT.VECT_DEP.B', 'V V R', neq, iadrb)
    endif
!
! --- CALCUL MODAL PROPREMENT DIT
!
    if (.not.lc) then
!
!     ------------------------------------------------------------------
!     ------------------------------------------------------------------
!     ---------------------  PROBLEME GENERALISE   ---------------------
!     ------------------------------------------------------------------
!     ------------------------------------------------------------------
!
!     ------------------------------------------------------------------
!     -------  LANCZOS PB GENERALISE REEL SYMETRIQUE -------------------
!     ------------------------------------------------------------------
        if (nstoc .ge. nbvect) call utmess('A', 'ALGELINE2_72')
        if (nstoc .ne. 0) then
            do i = 1, neq * nstoc
                zr(lvec + i - 1) = zr(lxrig + i -1)
            enddo
        endif
        call vp2ini(lmtpsc, lmasse, lmatra, neq, nbvect,&
                    nborto, prorto, zi(lprod), zi(lddl), zr(ldiagr),&
                    zr(lsurdr), zr(lsign), zr( lvec), prsudg, nstoc,&
                    omeshi, solveu)
        call vp2trd('G', nbvect, zr(ldiagr), zr(lsurdr), zr(lsign),&
                    zr(iadz), nitv, nitqrm)
        call vpreco(nbvect, neq, zr(iadz), zr(lvec))
        call rectfr(nfreq, nbvect, omeshi, npivot, nblagr,&
                    zr(ldiagr), nbvect, zi(lresui), zr(lresur), mxresf)
        call vpbost(typres, nfreq, nbvect, omeshi, zr(ldiagr),&
                    nbvect, vpinf, vpmax, precdc, method,&
                    omecor)
        if (typres(1:9) .eq. 'DYNAMIQUE') call vpordi(1, 0, nfreq, zr( lresur+mxresf), zr(lvec),&
                                                      neq, zi(lresui))
!
        do imet = 1, nfreq
            zi(lresui-1+ mxresf+imet) = nitqrm
            zr(lresur-1+imet) = freqom(zr(lresur-1+mxresf+imet))
!           SI OPTION 'PLUS_GRANDE' : CONVERSION EN VALEUR PHYSIQUE
            if (lpg) zr(lresur-1+imet) = +1.d0 / (quapi2 * zr( lresur-1+imet))
            zr(lresur-1+2*mxresf+imet) = rzero
            zk24(lresuk-1+ mxresf+imet)= kmetho
        enddo
        if (typres(1:9) .ne. 'DYNAMIQUE') then
            call vpordo(0, 0, nfreq, zr(lresur+mxresf), zr(lvec),&
                        neq)
            do imet = 1, nfreq
                zr(lresur-1+imet) = freqom(zr(lresur-1+mxresf+ imet))
                zi(lresui-1+imet) = imet
            enddo
        endif
!
    else
!
!     ------------------------------------------------------------------
!     ------------------------------------------------------------------
!     ---------------------  PROBLEME QUADRATIQUE   --------------------
!     ------------------------------------------------------------------
!     ------------------------------------------------------------------
!
!     ------------------------------------------------------------------
!     -------  LANCZOS PB QUADRATIQUE REEL SYMETRIQUE ------------------
!     ------------------------------------------------------------------
        call wp2ini(appr, lmasse, lamor, lraide, lmatra,&
                    lmtpsc, sigma, zr(iadrh), zr(iadrb), optiof,&
                    prorto, nborto, nbvect, neq, zi(lprod),&
                    zi(lddl), zr(ldiagr), zr(lsurdr), zr(lsign), zr(iadx),&
                    zr(iady), solveu)
        call vp2trd('Q', nbvect, zr(ldiagr), zr(lsurdr), zr(lsign),&
                    zr(iadz), nitv, nitqrm)
        npivot = nblagr
        nfreq = nfreq / 2
        call wp2vec(appr, optiof, nfreq, nbvect, neq,&
                    sigma, zr(iadx), zr(iady), zr(iadz), 2*nbvect,&
                    zr(lsurdr), zr(ldiagr), zc(lvec), mxresf, zi(lresui),&
                    zr(lresur), zi(lprod), omecor)
        do imet = 1, nfreq
            zi(lresui-1+mxresf+imet) = nitqrm
            zr(lresur-1+imet) = freqom(zr(lresur-1+mxresf+imet))
            zk24(lresuk-1+mxresf+imet) = kmetho
        enddo
!
    endif
!
! ---- NOMBRE DE MODES CONVERGES
! ---- SI LE SOLVEUR MODAL A BIEN ACHEVE SON TRAVAIL ON FAIT CETTE AFFEC
! ---- TATION SINON ON NE TIENT COMPTE QUE DES NCONV MODES REELLEMENT CV
    if (.not.flage) nconv = nfreq
!
!     ------------------------------------------------------------------
!     -------------------- CORRECTION : OPTION BANDE -------------------
!     ------------------------------------------------------------------
!
! --- SI OPTION BANDE ON NE GARDE QUE LES FREQUENCES DANS LA BANDE
    mfreq = nconv
    if (optiof(1:5) .eq. 'BANDE') then
        if (lc .or. lns .or. .not.lkr) then
            ASSERT(.false.)
        endif
        do ifreq = mfreq - 1, 0, -1
            if ((zr(lresur+mxresf+ifreq).gt.omemax) .or. (zr(lresur+ mxresf+ifreq).lt.omemin)) &
            nconv = nconv - 1
        enddo
        if (mfreq .ne. nconv) call utmess('I', 'ALGELINE2_17')
    endif
!
! ---  ON MODIFIE LES VALEURS NFREQ DE LA SD EIGENSOLVER
    call vpecri(eigsol, 'I', 1, k24bid, rbid,&
                nfreq)
!
!
! --- NETTOYAGE OBJETS TEMPORAIRES
!
    call jedetr('&&VPCALT.SELECT')
    call jedetr('&&VPCALT.MAT.DIAG')
    call jedetr('&&VPCALT.MAT.SUR.DIAG')
    call jedetr('&&VPCALT.SIGNES')
    if (.not.lc) then
        call jedetr('&&VPCALT.MAT.MOD.REDUITE')
    else
        call jedetr('&&VPCALT.VECT.LANCZOS')
        call jedetr('&&VPCALT.VECTY   ')
        call jedetr('&&VPCALT.MAT.MOD.REDUITE')
        call jedetr('&&VPCALT.VECT_DEP.H')
        call jedetr('&&VPCALT.VECT_DEP.B')
    endif
    if (nstoc .ne. 0) call jedetr(vecrig)
    call jedema()
!
!     FIN DE VPCALT
!
end subroutine
