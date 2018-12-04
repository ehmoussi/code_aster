! --------------------------------------------------------------------
! Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
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
! person_in_charge: samuel.geniaut at edf.fr
!
subroutine te0534(option, nomte)
!
implicit none
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/elelin.h"
#include "asterfort/elref1.h"
#include "asterfort/elrefe_info.h"
#include "asterfort/jevech.h"
#include "asterfort/lteatt.h"
#include "asterfort/teattr.h"
#include "asterfort/tecach.h"
#include "asterfort/tecael.h"
#include "asterfort/xdocon.h"
#include "asterfort/xmprep.h"
#include "asterfort/xmulco.h"
#include "asterfort/xteddl.h"
#include "asterfort/xteini.h"
#include "asterfort/xvcont.h"
#include "asterfort/xvfrot.h"
#include "asterfort/xxlagm.h"
#include "asterfort/xkamat.h"
!
character(len=16) :: option, nomte
!
! --------------------------------------------------------------------------------------------------
!
!               CALCUL DES SECONDS MEMBRES DE CONTACT FROTTEMENT
!                   POUR X-FEM  (METHODE CONTINUE)
!
! --------------------------------------------------------------------------------------------------
!
!  OPTION : 'CHAR_MECA_CONT' (CALCUL DU SECOND MEMBRE DE CONTACT)
!
!  ENTREES  ---> OPTION : OPTION DE CALCUL
!           ---> NOMTE  : NOM DU TYPE ELEMENT
!
! --------------------------------------------------------------------------------------------------
!
    integer :: i, ifa, ipgf, isspg
    integer :: jindco, jdonco, jlst, igeom
    integer :: idepm, idepl, jptint, jaint, jcface, jlonch
    integer :: ivff, iadzi, iazk24, ibid, jbasec
    integer :: jv_cont, jv_fric
    integer :: ndim, nfh, ddlc, ddls, nddl, nno, nnos, nnom, nnof, ddlm
    integer :: npgf, jseuil
    integer :: indco, ninter, nface, cface(30, 6)
    integer :: nfe, singu, jstno, nvit, algocr, algofr, nvec
    integer :: nnol, pla(27), lact(8), nlact, jcohes, jheavn
    integer :: jmate, nfiss, jfisno, contac, nbspg, nspfis
    integer :: jheano, ifiss, ncomph, ncompv, vstnc(32)
    integer :: jtab(7), iret, ncompd, ncompp, ncompa, ncompb, ncompc, ncompn
    integer :: jheafa, nptf, jta2(3)
    integer :: jbaslo, jlsn
    real(kind=8) :: vcont(400), vfric(400), reac, reac12(3), jac
    real(kind=8) :: nd(3), ffp(27), ffc(8), seuil, coefcp, coefcr, coeffp
    real(kind=8) :: mu, tau1(3), tau2(3), coeffr
    real(kind=8) :: rr, cohes(3), rela
    real(kind=8) :: ka, mu2, fk(27,3,3)
    aster_logical :: lbid, lelim
    aster_logical :: axi
    character(len=8) :: elref, typma, elrefc
    character(len=8) :: elc, fpg
    character(len=16) :: enr
!
! --------------------------------------------------------------------------------------------------
!
    lact(:)  = 0
    ffp(:)   = 0.d0
    tau2(:)  = 0.d0
    rr       = 0.d0
    ncomph   = 0
    lelim    = ASTER_FALSE
    nbspg    = 0
    vcont(:) = 0.d0
    vfric(:) = 0.d0
!
! - Get informations about finite element
!
    call elref1(elref)
    call elrefe_info(fami='RIGI', ndim=ndim, nno=nno, nnos=nnos)
    call tecael(iadzi, iazk24, noms=0)
    typma = zk24(iazk24-1+3+zi(iadzi-1+2)+3)(1:8)
!
! - Get sizes and dimensions
!
    call xteini(nomte, nfh, nfe, singu, ddlc,&
                nnom, ddls, nddl, ddlm, nfiss,&
                contac)
    ASSERT(nddl .le. 400)
!
! --- ROUTINE SPECIFIQUE P2P1
!
    call elelin(contac, elref, elrefc, ibid, ibid)
!
! --- RECUPERATION DES ENTRÉES / SORTIE
!
    call jevech('PGEOMER', 'L', igeom)
!     DEPLACEMENT A L'EQUILIBRE PRECEDENT  (DEPMOI)       : 'PDEPL_M'
    call jevech('PDEPL_M', 'L', idepm)
!     INCREMENT DE DEP DEPUIS L'EQUILIBRE PRECEDENT (DEPDEL) :'PDEPL_P'
    call jevech('PDEPL_P', 'L', idepl)
    call jevech('PINDCOI', 'L', jindco)
    call jevech('PDONCO', 'L', jdonco)
    call tecach('OOO', 'PDONCO', 'L', ibid, nval=2,&
                itab=jtab)
    ncompd = jtab(2)
    call jevech('PSEUIL', 'L', jseuil)
    call jevech('PLST', 'L', jlst)
    call jevech('PPINTER', 'L', jptint)
    call jevech('PAINTER', 'L', jaint)
    call jevech('PCFACE', 'L', jcface)
    call jevech('PLONGCO', 'L', jlonch)
    call jevech('PBASECO', 'L', jbasec)
    if (nfh.gt.0) then
        call jevech('PHEA_NO', 'L', jheavn)
        call tecach('OOO', 'PHEA_NO', 'L', iret, nval=7,&
                itab=jtab)
        ncompn = jtab(2)/jtab(3)
    endif
    if (nfiss .gt. 1) then
        call jevech('PFISNO', 'L', jfisno)
        call jevech('PHEAVNO', 'L', jheano)
        call jevech('PHEA_FA', 'L', jheafa)
        call tecach('OOO', 'PHEA_FA', 'L', iret, nval=2,&
                    itab=jtab)
        ncomph = jtab(2)
    endif
!     DIMENSSION DES GRANDEURS DANS LA CARTE
    call tecach('OOO', 'PDONCO', 'L', iret, nval=2, itab=jtab)
    ncompd = jtab(2)
    call tecach('OOO', 'PPINTER', 'L', iret, nval=2, itab=jtab)
    ncompp = jtab(2)
    call tecach('OOO', 'PAINTER', 'L', iret, nval=2, itab=jtab)
    ncompa = jtab(2)
    call tecach('OOO', 'PBASECO', 'L', iret, nval=2, itab=jtab)
    ncompb = jtab(2)
    call tecach('OOO', 'PCFACE', 'L', iret, nval=2, itab=jtab)
    ncompc = jtab(2)
    if (nfe.gt.0) then
       call jevech('PMATERC', 'L', jmate)
       call jevech('PBASLOR', 'L', jbaslo)
       call jevech('PLSN', 'L', jlsn)
       call jevech('PSTANO', 'L', jstno)
       axi=lteatt('AXIS','OUI')
    else
       ka=3.d0
       mu2=1.d0
       axi= ASTER_FALSE
       jmate=0
       jbaslo=0
       jlsn=0
       jstno=0
    endif
!
!     STATUT POUR L'ÉLIMINATION DES DDLS DE CONTACT
    do i = 1, max(1, nfh)*nnos
        vstnc(i) = 1
    end do
    call teattr('S', 'XFEM', enr, ibid)
!
! --- BOUCLE SUR LES FISSURES
!
    do ifiss = 1, nfiss
!
! --- RECUPERATION DIVERSES DONNEES CONTACT
!
        call xdocon(algocr, algofr, cface, contac, coefcp,&
                    coeffp, coefcr, coeffr, elc, fpg,&
                    ifiss, ivff, jcface, jdonco, jlonch,&
                    mu, nspfis, ncompd, ndim, nface,&
                    ninter, nnof, nomte, npgf, nptf,&
                    rela)
        if (ninter .ne. 0) then
! --------- RECUPERATION MATERIAU ET VARIABLES INTERNES COHESIF
            if (algocr .eq. 3) then
                call jevech('PMATERC', 'L', jmate)
                call jevech('PCOHES', 'L', jcohes)
                call tecach('OOO', 'PCOHES', 'L', iret, nval=3,&
                            itab=jta2)
                if (contac .eq. 2) then
                    ncompv = jta2(2)/jta2(3)
                elseif (contac .eq. 1 .or. contac .eq. 3) then
                    ncompv = jta2(2)
                else
                    ASSERT(ASTER_FALSE)
                endif
            endif
! --------- RECUP MULTIPLICATEURS ACTIFS ET LEURS INDICES
            call xmulco(contac, ddls, ddlc, ddlm, jaint, ifiss,&
                        jheano, vstnc, lact, .true._1, lelim,&
                        ndim, nfh, nfiss, ninter,&
                        nlact, nno, nnol, nnom, nnos,&
                        pla, typma)
! --------- BOUCLE SUR LES FACETTES
            do ifa = 1, nface
! ------------- BOUCLE SUR LES POINTS DE GAUSS DES FACETTES
                do ipgf = 1, npgf
! ----------------- RECUPERATION DES STATUTS POUR LE POINT DE GAUSS
                    isspg = npgf*(ifa-1)+ipgf
                    indco = zi(jindco-1+nbspg+isspg)
                    if (algofr .ne. 0) then
                        seuil = zr(jseuil-1+nbspg+isspg)
                    endif
! ----------------- SI COHESIF CLASSIQUE, ON LIT LES VARIABLES INTERNES
                    if (algocr .eq. 3 .and. (contac.eq.1 .or. contac.eq.3)) then
                        do i = 1, ncompv
                            cohes(i) = zr(jcohes+ncompv*(nbspg+isspg-1)-1+ i)
                        end do
                    endif
! ----------------- PREPARATION DU MATERIAU POUR L ENRICHISSEMENT VECTORIEL EN FOND
                    if (nfe.gt.0) then
                        call xkamat(zi(jmate), ndim, axi, ka, mu2)
                    endif
!
                    call xmprep(cface, contac, elref, elrefc, elc,&
                                ffc, ffp, fpg, jaint, jbasec,&
                                jptint, ifa, igeom, ipgf, jac,&
                                jlst, lact, nd, ndim, ninter,&
                                nlact, nno, nnos, nptf, nvit,&
                                rr, singu, tau1, tau2, ka, mu2,&
                                jbaslo, jstno, jlsn, fk)
! ----------------- CALCUL REACTION DE CONTACT ET DE FROTTEMENT
                    nvec = 2
                    call xxlagm(ffc, idepl, idepm, lact, ndim,&
                                nnol, pla, reac, reac12, tau1,&
                                tau2, nvec)
! ----------------- CALCUL DES SECONDS MEMBRES DE CONTACT
                    call xvcont(algocr, cohes, jcohes, ncompv,&
                                coefcp, coefcr, ddlm,&
                                ddls, ffc, ffp, idepl, idepm,&
                                ifa, ifiss, zi( jmate), indco, ipgf,&
                                jac, jheavn, ncompn, jheafa, lact, ncomph,&
                                nd, nddl, ndim, nfh, nfiss,&
                                nno, nnol, nnos, nvit, pla,&
                                rela, reac, singu, fk, tau1,&
                                tau2, vcont)
! ----------------- CALCUL DES SECONDS MEMBRES DE FROTTEMENT
                    if (rela .eq. 0.d0 .or. rela .eq. 1.d0 .or. rela .eq. 2.d0) then
                        call xvfrot(algofr, coeffp, coeffr, ddlm, ddls,&
                                    ffc, ffp, idepl, idepm, ifa,&
                                    ifiss, indco, jac, jheavn, ncompn, jheafa,&
                                    lact, mu, ncomph, nd, nddl,&
                                    ndim, nfh, nfiss, nno, nnol,&
                                    nnos, nvit, pla, reac12,&
                                    seuil, singu, fk, tau1, tau2, vfric)
                    endif
                end do
            end do
            nbspg = nbspg + nspfis
        endif
        jbasec = jbasec + ncompb
        jptint = jptint + ncompp
        jaint = jaint + ncompa
        jcface = jcface + ncompc
    end do
!
!-----------------------------------------------------------------------
!     COPIE DES CHAMPS DE SORTIES ET FIN
!-----------------------------------------------------------------------
!
    call jevech('PVECTCR', 'E', jv_cont)
    if (algofr.eq.0) then
        do i = 1, nddl
            zr(jv_cont-1+i) = vcont(i)+vfric(i)
        end do
    else
        do i = 1, nddl
            zr(jv_cont-1+i) = vcont(i)
        end do
    endif
    if (algofr.gt.0) then
        call jevech('PVECTFR', 'E', jv_fric)
        do i = 1, nddl
            zr(jv_fric-1+i) = vfric(i)
        end do
    endif
!     SUPPRESSION DES DDLS DE DEPLACEMENT SEULEMENT POUR LES XHTC
    if (nfh .ne. 0) then
        call jevech('PSTANO', 'L', jstno)
        call xteddl(ndim, nfh, nfe, ddls, nddl,&
                    nno, nnos, zi(jstno), .false._1, lbid,&
                    option, nomte, ddlm, nfiss, jfisno,&
                    vect=zr(jv_cont))
        if (algofr .gt. 0) then
            call xteddl(ndim, nfh, nfe, ddls, nddl,&
                        nno, nnos, zi(jstno), .false._1, lbid,&
                        option, nomte, ddlm, nfiss, jfisno,&
                        vect=zr(jv_fric))
        endif
    endif
!     SUPPRESSION DES DDLS DE CONTACT
    if (lelim) then
        call xteddl(ndim, nfh, nfe, ddls, nddl,&
                    nno, nnos, vstnc, .true._1, .true._1,&
                    option, nomte, ddlm, nfiss, jfisno,&
                    vect=zr(jv_cont))
        if (algofr .gt. 0) then
            call xteddl(ndim, nfh, nfe, ddls, nddl,&
                        nno, nnos, vstnc, .true._1, .true._1,&
                        option, nomte, ddlm, nfiss, jfisno,&
                        vect=zr(jv_fric))
        endif
    endif
!
end subroutine
