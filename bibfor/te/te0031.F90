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
!
subroutine te0031(option, nomte)
!
implicit none
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/codent.h"
#include "asterfort/cosiro.h"
#include "asterfort/dkqmas.h"
#include "asterfort/dkqrig.h"
#include "asterfort/dktmas.h"
#include "asterfort/dktnli.h"
#include "asterfort/dktrig.h"
#include "asterfort/dsqmas.h"
#include "asterfort/dsqrig.h"
#include "asterfort/dstmas.h"
#include "asterfort/dstrig.h"
#include "asterfort/dxbsig.h"
#include "asterfort/dxeffi.h"
#include "asterfort/dxiner.h"
#include "asterfort/dxqpgl.h"
#include "asterfort/dxroep.h"
#include "asterfort/dxtpgl.h"
#include "asterfort/elrefe_info.h"
#include "asterfort/jevech.h"
#include "asterfort/pmavec.h"
#include "asterfort/q4gmas.h"
#include "asterfort/q4grig.h"
#include "asterfort/rccoma.h"
#include "asterfort/rcvalb.h"
#include "asterfort/t3grig.h"
#include "asterfort/tecach.h"
#include "asterfort/terefe.h"
#include "asterfort/utmess.h"
#include "asterfort/utpslg.h"
#include "asterfort/utpvgl.h"
#include "asterfort/utpvlg.h"
#include "asterfort/vecma.h"
#include "asterc/r8prem.h"
#include "asterfort/Behaviour_type.h"
#include "asterfort/plateChckHomo.h"
!
character(len=16), intent(in) :: option, nomte
!
! --------------------------------------------------------------------------------------------------
!
! Elementary computation
!
! Elements: DKT, DST, Q4G
!
! Options: FULL_MECA_*, RIGI_MECA_*, RAPH_MECA
!          REFE_FORC_NODA, FORC_NODA
!          EPOT_ELEM, ECIN_ELEM
!          MASS_MECA, MASS_MECA_DIAG, MASS_MECA_EXPLI, M_GAMMA, MASS_INER
!
!
! --------------------------------------------------------------------------------------------------
!
! In  option           : name of option to compute
! In  nomte            : type of finite element
!
! --------------------------------------------------------------------------------------------------
!
    integer, parameter :: npge = 3
    integer :: ndim, nno, ind
    integer :: multic, codret(1), jdepm, jdepr
    integer :: icompo, i1, i2, j, jvect
    integer :: k, jcret, jfreq, iacce
    integer :: jgeom, jmatr, jener, i
    integer :: ivect, nddl, nvec, iret, icontp
    integer :: nbcou, jnbspi, iret1, itab(7), nbsp
    integer :: ibid, n1, n2, ni
    real(kind=8) :: pgl(3, 3), xyzl(3, 4), bsigma(24), effgt(32)
    real(kind=8) :: effref, momref
    real(kind=8) :: vecloc(24), ener(3), matp(24, 24), matv(300)
    real(kind=8) :: foref, moref
    character(len=16) :: defo_comp
    aster_logical :: lcqhom, l_nonlin
!     ---> POUR DKT/DST MATELEM = 3 * 6 DDL = 171 TERMES STOCKAGE SYME
!     ---> POUR DKQ/DSQ MATELEM = 4 * 6 DDL = 300 TERMES STOCKAGE SYME
    real(kind=8) :: matloc(300), rho, epais
!     --->   UML : DEPLACEMENT A L'INSTANT T- (REPERE LOCAL)
!     --->   DUL : INCREMENT DE DEPLACEMENT   (REPERE LOCAL)
    real(kind=8) :: uml(6, 4), dul(6, 4)
!
! --------------------------------------------------------------------------------------------------
!
    call elrefe_info(fami='RIGI', ndim=ndim, nno=nno)
    ASSERT(nno .eq. 3 .or. nno .eq. 4)
!

    if (option .ne. 'REFE_FORC_NODA') then
! --- PASSAGE DES CONTRAINTES DANS LE REPERE INTRINSEQUE :
        call cosiro(nomte, 'PCONTMR', 'L', 'UI', 'G', ibid, 'S')
        call cosiro(nomte, 'PCONTRR', 'L', 'UI', 'G', ibid, 'S')
        jnbspi=0
        call tecach('NNO', 'PNBSP_I', 'L', iret1, iad=jnbspi)
    endif
!
    l_nonlin = (option(1:9).eq.'FULL_MECA').or.&
               (option.eq.'RAPH_MECA').or.&
               (option(1:10).eq.'RIGI_MECA_')
!
! - Check consistency between DEFI_COQU_MULT/AFFE_CARA_ELEM
!
    lcqhom   = ASTER_FALSE
    call plateChckHomo(l_nonlin, option, lcqhom)
!
! - Compute matrix for local basis 
!
    call jevech('PGEOMER', 'L', jgeom)
    if (nno .eq. 3) then
        call dxtpgl(zr(jgeom), pgl)
    else if (nno .eq. 4) then
        call dxqpgl(zr(jgeom), pgl, 'S', iret)
    endif
    call utpvgl(nno, 3, pgl, zr(jgeom), xyzl)
!
    if (option .eq. 'RIGI_MECA' .or. option .eq. 'EPOT_ELEM') then
!     --------------------------------------
!
        if (nomte .eq. 'MEDKTR3') then
            call dktrig(nomte, xyzl, option, pgl, matloc, ener, multic)
        else if (nomte.eq.'MEDSTR3') then
            call dstrig(nomte, xyzl, option, pgl, matloc, ener)
        else if (nomte.eq.'MEDKQU4') then
            call dkqrig(nomte, xyzl, option, pgl, matloc, ener)
        else if (nomte.eq.'MEDSQU4') then
            call dsqrig(nomte, xyzl, option, pgl, matloc, ener)
        else if (nomte.eq.'MEQ4QU4') then
            call q4grig(nomte, xyzl, option, pgl, matloc, ener)
        else if (nomte.eq.'MET3TR3') then
            call t3grig(nomte, xyzl, option, pgl, matloc, ener)
        endif
!
        if (option .eq. 'RIGI_MECA') then
            call jevech('PMATUUR', 'E', jmatr)
            call utpslg(nno, 6, pgl, matloc, zr(jmatr))
!
        else if (option.eq.'EPOT_ELEM') then
            call jevech('PENERDR', 'E', jener)
            do i = 1, 3
                zr(jener-1+i)=ener(i)
            enddo
        endif
!
    else if ( (option.eq.'MASS_MECA') .or. (option.eq.'MASS_MECA_DIAG') .or. &
              (option.eq.'MASS_MECA_EXPLI') .or. (option.eq.'M_GAMMA') .or. &
              (option.eq.'ECIN_ELEM') ) then
!
        if (nomte .eq. 'MEDKTR3' .or. nomte .eq. 'MET3TR3') then
            call dktmas(xyzl, option, pgl, matloc, ener)
        else if (nomte.eq.'MEDSTR3') then
            call dstmas(xyzl, option, pgl, matloc, ener)
        else if (nomte.eq.'MEDKQU4') then
            call dkqmas(xyzl, option, pgl, matloc, ener)
        else if (nomte.eq.'MEDSQU4') then
            call dsqmas(xyzl, option, pgl, matloc, ener)
        else if (nomte.eq.'MEQ4QU4') then
            call q4gmas(xyzl, option, pgl, matloc, ener)
        endif
        if (option .eq. 'MASS_MECA') then
            call jevech('PMATUUR', 'E', jmatr)
            call utpslg(nno, 6, pgl, matloc, zr(jmatr))
        else if (option.eq.'ECIN_ELEM') then
            call jevech('PENERCR', 'E', jener)
            call jevech('POMEGA2', 'L', jfreq)
            do i = 1, 3
                zr(jener-1+i)=zr(jfreq)*ener(i)
            enddo
        else if (option.eq.'M_GAMMA') then
            call jevech('PACCELR', 'L', iacce)
            call jevech('PVECTUR', 'E', ivect)
            nddl=6*nno
            nvec=nddl*(nddl+1)/2
            call utpslg(nno, 6, pgl, matloc, matv)
            call vecma(matv, nvec, matp, nddl)
            call pmavec('ZERO', nddl, matp, zr(iacce), zr(ivect))
        else if (option.eq.'MASS_MECA_DIAG' .or. option.eq.'MASS_MECA_EXPLI') then
            call jevech('PMATUUR', 'E', jmatr)
            nddl=6*nno
            ndim=nddl*(nddl+1)/2
            do i = 1, ndim
                zr(jmatr-1+i)=matloc(i)
            enddo
            if (option .eq. 'MASS_MECA_EXPLI') then
!               CORRECTION DES TERMES CORRESPONDANT AU DDL 6
!               NON PREVU PAR LA THEORIE DKT. ON RAJOUTE
!               UN TERME DIAGONAL NON ZERO EGAL A CELUI DU DDL 5.
!               CETTE CORRECTION A ETE INSPIRE PAR LA DEMARCHE DANS EUROPLEXUS
                do j = 1, nno
                    n1=6*(j-1)+5
                    n2=6*(j-1)+4
                    ni=6*j
                    ndim=(ni+1)*ni/2
                    n1=(n1+1)*n1/2
                    n2=(n2+1)*n2/2
                    zr(jmatr-1+ndim)=(zr(jmatr-1+n1)+zr(jmatr-1+n2))*0.5d0
                enddo
            endif
        endif
!
    else if (option.eq.'MASS_INER') then
!     -----------------------------------
        call jevech('PMASSINE', 'E', jmatr)
        call dxroep(rho, epais)
        call dxiner(nno, zr(jgeom), rho, epais, zr(jmatr),&
                    zr(jmatr+1), zr(jmatr+4))
!
    else if (l_nonlin) then
!
        call jevech('PDEPLMR', 'L', jdepm)
        call jevech('PDEPLPR', 'L', jdepr)
        call jevech('PCOMPOR', 'L', icompo)
        if (lcqhom) then
            call utmess('F', 'PLATE1_75')
        endif
        defo_comp = zk16(icompo-1+DEFO)
        if ((defo_comp(6:10).eq.'_REAC') .or. (defo_comp.eq.'GROT_GDEP')) then
            do i = 1, nno
                i1=3*(i-1)
                i2=6*(i-1)
                zr(jgeom+i1) = zr(jgeom+i1) + zr(jdepm+i2) + zr(jdepr+i2)
                zr(jgeom+i1+1) = zr(jgeom+i1+1) + zr(jdepm+i2+1) + zr(jdepr+i2+1)
                zr(jgeom+i1+2) = zr(jgeom+i1+2) + zr(jdepm+i2+2) + zr(jdepr+i2+2)
            enddo
!
            if (nno .eq. 3) then
                call dxtpgl(zr(jgeom), pgl)
            else if (nno.eq.4) then
                call dxqpgl(zr(jgeom), pgl, 'S', iret)
            endif
            call utpvgl(nno, 3, pgl, zr(jgeom), xyzl)
!
        endif
!
        call utpvgl(nno, 6, pgl, zr(jdepm), uml)
        call utpvgl(nno, 6, pgl, zr(jdepr), dul)
!
        if (nomte .eq. 'MEDKTR3') then
            call dktnli(nomte, option, xyzl,pgl, uml, dul,&
                        vecloc, matloc, codret(1))
        else if (nomte.eq.'MEDKQU4 ') then
            call dktnli(nomte, option, xyzl,pgl, uml, dul,&
                        vecloc, matloc, codret(1))
        else
            ASSERT(ASTER_FALSE)
        endif
!
        if (option(1:9) .eq. 'FULL_MECA') then
            call jevech('PMATUUR', 'E', jmatr)
            call jevech('PVECTUR', 'E', jvect)
            call utpslg(nno, 6, pgl, matloc, zr(jmatr))
            call utpvlg(nno, 6, pgl, vecloc, zr(jvect))
        else if (option .eq. 'RAPH_MECA') then
            call jevech('PVECTUR', 'E', jvect)
            call utpvlg(nno, 6, pgl, vecloc, zr(jvect))
        else if (option(1:10) .eq. 'RIGI_MECA_') then
            call jevech('PMATUUR', 'E', jmatr)
            call utpslg(nno, 6, pgl, matloc, zr(jmatr))
        endif
!
!
    else if (option.eq.'FORC_NODA') then
!     -------------------------------------
        effgt = 0.d0
        call tecach('OOO', 'PCONTMR', 'L', iret, nval=7, itab=itab)
        icontp=itab(1)
        nbsp=itab(7)
        nbcou=zi(jnbspi)
!
        if (nbsp .ne. npge*nbcou) then
            call utmess('F', 'PLATE1_4')
        endif
!
        ind=8
        call dxeffi(option, nomte, pgl, zr(icontp), ind, effgt)
!
        call tecach('NNO', 'PCOMPOR', 'L', iret, iad=icompo)
        if (icompo .ne. 0) then
            defo_comp = zk16(icompo-1+DEFO)
            if ((defo_comp(6:10).eq.'_REAC') .or. (defo_comp .eq.'GROT_GDEP')) then
                call jevech('PDEPLMR', 'L', jdepm)
                call jevech('PDEPLPR', 'L', jdepr)
                do i = 1, nno
                    i1 = 3* (i-1)
                    i2 = 6* (i-1)
                    zr(jgeom+i1) = zr(jgeom+i1) + zr(jdepm+i2) + zr(jdepr+i2)
                    zr(jgeom+i1+1) = zr(jgeom+i1+1) + zr(jdepm+i2+1) + zr(jdepr+i2+1)
                    zr(jgeom+i1+2) = zr(jgeom+i1+2) + zr(jdepm+i2+2) + zr(jdepr+i2+2)
                end do
                if (nno .eq. 3) then
                    call dxtpgl(zr(jgeom), pgl)
                else if (nno.eq.4) then
                    call dxqpgl(zr(jgeom), pgl, 'S', iret)
                endif
                call utpvgl(nno, 3, pgl, zr(jgeom), xyzl)
            endif
        endif
!
! ------ CALCUL DES EFFORTS INTERNES (I.E. SOMME_VOL(BT_SIG))
        call dxbsig(nomte, xyzl, pgl, effgt, bsigma, option)
!
! ------ AFFECTATION DES VALEURS DE BSIGMA AU VECTEUR EN SORTIE
        call jevech('PVECTUR', 'E', jvect)
        k=0
        do i = 1, nno
            do j = 1, 6
                k=k+1
                zr(jvect+k-1)=bsigma(k)
            enddo
        enddo
!
    else if (option.eq.'REFE_FORC_NODA') then
!     -------------------------------------
        call terefe('EFFORT_REFE', 'MECA_COQUE', foref)
        call terefe('MOMENT_REFE', 'MECA_COQUE', moref)
!
        ind=8
        do i = 1, nno
            do j = 1, 3
                effgt((i-1)*ind+j) = foref
                effgt((i-1)*ind+3+j) = moref
            enddo
        enddo
!
! ------ CALCUL DES EFFORTS INTERNES (I.E. SOMME_VOL(BT_SIG))
        call dxbsig(nomte, xyzl, pgl, effgt, bsigma, option)
!
! ------ AFFECTATION DES VALEURS DE BSIGMA AU VECTEUR EN SORTIE
        call jevech('PVECTUR', 'E', jvect)
        k=0
        do i = 1, nno
            effref=(abs(bsigma(k+1))+abs(bsigma(k+2))+abs(bsigma(k+3)))/3.d0
            momref=(abs(bsigma(k+4))+abs(bsigma(k+5))+abs(bsigma(k+6)))/3.d0
            do j = 1, 6
                k=k+1
                if (j .lt. 4) then
                    zr(jvect+k-1) = effref
                else
                    zr(jvect+k-1) = momref
                endif
            enddo
        enddo
    else
        ASSERT(ASTER_FALSE)
    endif
!
    if (option(1:9) .eq. 'FULL_MECA' .or. option(1:9) .eq. 'RAPH_MECA') then
        call jevech('PCODRET', 'E', jcret)
        zi(jcret)=codret(1)
    endif
!
    if (option .ne. 'REFE_FORC_NODA') then
! --- PASSAGE DES CONTRAINTES DANS LE REPERE UTILISATEUR :
        call cosiro(nomte, 'PCONTPR', 'E', 'IU', 'G', ibid, 'R')
    endif
!
end subroutine
