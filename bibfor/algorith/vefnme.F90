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
! person_in_charge: mickael.abbas at edf.fr
!
subroutine vefnme(option_, model     , mate , cara_elem_,&
                  compor , partps    , nh   , ligrel_   ,&
                  varc_  , sigm_     , strx_,&
                  disp_  , disp_incr_,&
                  base   , vect_elem_)
!
implicit none
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/calcul.h"
#include "asterfort/corich.h"
#include "asterfort/dbgcal.h"
#include "asterfort/detrsd.h"
#include "asterfort/dismoi.h"
#include "asterfort/exixfe.h"
#include "asterfort/gcnco2.h"
#include "asterfort/infdbg.h"
#include "asterfort/inical.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/mecact.h"
#include "asterfort/mecara.h"
#include "asterfort/memare.h"
#include "asterfort/reajre.h"
#include "asterfort/codent.h"
#include "asterfort/exisd.h"
#include "asterfort/sepach.h"
#include "asterfort/copisd.h"
!
character(len=16), intent(in) :: option_
character(len=1), intent(in) :: base
character(len=8), intent(in) :: model
real(kind=8), intent(in) :: partps(*)
character(len=24), intent(in) :: cara_elem_, mate
character(len=*), intent(in) :: ligrel_
integer, intent(in) :: nh
character(len=19), intent(in) :: compor
character(len=*), intent(in) :: sigm_, varc_, strx_, disp_, disp_incr_
character(len=*), intent(inout) :: vect_elem_
!
! --------------------------------------------------------------------------------------------------
!
! Elementary computation
!
! Option: FORC_NODA
!         FONL_NOEU
!
! --------------------------------------------------------------------------------------------------
!
!
! IN  MODELE : NOM DU MODELE (NECESSAIRE SI SIGMA EST UNE CARTE)
! IN  SIGMA  : NOM DU CHAM_ELEM (OU DE LA CARTE) DE CONTRAINTES
! IN  CARA   : NOM DU CARA_ELEM
! IN  DEPMOI : NOM DU CHAM_NO DE DEPLACEMENTS PRECEDENTS
! IN  DEPDEL : NOM DU CHAM_NO D'INCREMENT DEPLACEMENTS
! IN  MATCOD : NOM DU MATERIAU CODE
! IN  COMPOR : NOM DE LA CARTE DE COMPORTEMENT
! IN  NH     : NUMERO D'HARMONIQUE DE FOURIER
! IN  PARTPS : INSTANT PRECEDENT ET ACTUEL
! IN  CARCRI : CARTE DES CRITERES ET DE THETA
! IN  CHVARC : NOM DU CHAMP DE VARIABLE DE COMMANDE
! IN  LIGREZ : (SOUS-)LIGREL DE MODELE POUR CALCUL REDUIT
!                  SI ' ', ON PREND LE LIGREL DU MODELE
! OUT VECELZ : VECT_ELEM RESULTAT.
!
!
! --------------------------------------------------------------------------------------------------
!
    integer, parameter :: nbout = 1
    integer, parameter :: nbin  = 32
    character(len=8) :: lpaout(nbout), lpain(nbin)
    character(len=19) :: lchout(nbout), lchin(nbin)
!
    character(len=8) :: mesh
    character(len=8) :: newnom, cara_elem
    character(len=19) :: chharm, tpsmoi, tpsplu, ligrel_local, ligrel
    character(len=19) :: chgeom, chcara(18), vect_elem
    character(len=16) :: option
    integer :: ibid, iret
    real(kind=8) :: instm, instp
    character(len=19) :: pintto, cnseto, heavto, loncha, basloc, lsn, lst, stano
    character(len=19) :: pmilto, fissno, hea_no
    character(len=19) :: sigm, varc, strx
    character(len=19) :: disp, disp_incr
!
! --------------------------------------------------------------------------------------------------
!
    call jemarq()
!
! - Initializations
!
    cara_elem = cara_elem_(1:8)
    sigm      = sigm_
    varc      = varc_
    strx      = strx_
    disp      = disp_
    disp_incr = disp_incr_
    ligrel    = ligrel_
    newnom    = '.0000000'
    chharm    = '&&VEFNME.NUME_HARM'
    tpsmoi    = '&&VEFNME.CH_INSTAM'
    tpsplu    = '&&VEFNME.CH_INSTAP'
    option    = option_
    if (option_ .ne. 'FONL_NOEU') then
        option = 'FORC_NODA'
    endif
    if (ligrel .eq. ' ') then
        ligrel_local = model(1:8)//'.MODELE'
    else
        ligrel_local = ligrel
    endif
!
! - Get mesh
!
    if (disp .ne. ' ') then
        call dismoi('NOM_MAILLA', disp, 'CHAM_NO', repk=mesh)
    else if (sigm.ne.' ') then
        call dismoi('NOM_MAILLA', sigm, 'CHAM_ELEM', repk=mesh)
    else
        ASSERT(ASTER_FALSE)
    endif
    chgeom = mesh(1:8)//'.COORDO'
!
! - VECT_ELEM name
!
    vect_elem = vect_elem_
    if (vect_elem .eq. ' ') then
        vect_elem = '&&VEFNME'
    endif
!
! - <CARTE> for structural elements
!
    call mecara(cara_elem(1:8), chcara)
!
! - <CARTE> for Fourier mode
!
    call mecact('V', chharm, 'MAILLA', mesh, 'HARMON',&
                ncmp=1, nomcmp='NH', si=nh)
!
! - <CARTE> for instant
!
    instm = partps(1)
    instp = partps(2)
    call mecact('V', tpsmoi, 'MAILLA', mesh, 'INST_R',&
                ncmp=1, nomcmp='INST', sr=instm)
    call mecact('V', tpsplu, 'MAILLA', mesh, 'INST_R',&
                ncmp=1, nomcmp='INST', sr=instp)
!
! - Init fields
!
    call inical(nbin, lpain, lchin, nbout, lpaout, lchout)
!
! - CREATION DES LISTES DES CHAMPS IN
!
    lpain(1) = 'PGEOMER'
    lchin(1) = chgeom
    lpain(2) = 'PMATERC'
    lchin(2) = mate(1:19)
    lpain(3) = 'PCAGNPO'
    lchin(3) = chcara(6)
    lpain(4) = 'PCAORIE'
    lchin(4) = chcara(1)
    lpain(5) = 'PCOMPOR'
    lchin(5) = compor
    lpain(6) = 'PCONTMR'
    lchin(6) = sigm
    lpain(7) = 'PDEPLMR'
    lchin(7) = disp
    lpain(8) = 'PDEPLPR'
    lchin(8) = disp_incr
    lpain(9) = 'PCAARPO'
    lchin(9) = chcara(9)
    lpain(10) = 'PCADISK'
    lchin(10) = chcara(2)
    lpain(11) = 'PCACOQU'
    lchin(11) = chcara(7)
    lpain(12) = 'PHARMON'
    lchin(12) = chharm
    lpain(13) = 'PCAMASS'
    lchin(13) = chcara(12)
    lpain(14) = 'PINSTMR'
    lchin(14) = tpsmoi
    lpain(15) = 'PINSTPR'
    lchin(15) = tpsplu
    lpain(16) = 'PVARCPR'
    lchin(16) = varc
    lpain(17) = 'PCAGEPO'
    lchin(17) = chcara(5)
    lpain(18) = 'PNBSP_I'
    lchin(18) = chcara(16)
    lpain(19) = 'PFIBRES'
    lchin(19) = chcara(17)
!
! --- CADRE X-FEM
!
    call exixfe(model, iret)
    if (iret .ne. 0) then
        pintto = model(1:8)//'.TOPOSE.PIN'
        cnseto = model(1:8)//'.TOPOSE.CNS'
        heavto = model(1:8)//'.TOPOSE.HEA'
        loncha = model(1:8)//'.TOPOSE.LON'
        pmilto = model(1:8)//'.TOPOSE.PMI'
        basloc = model(1:8)//'.BASLOC'
        lsn = model(1:8)//'.LNNO'
        lst = model(1:8)//'.LTNO'
        stano = model(1:8)//'.STNO'
        fissno = model(1:8)//'.FISSNO'
        hea_no = model(1:8)//'.TOPONO.HNO'
    else
        pintto = '&&VEFNME.PINTTO.BID'
        cnseto = '&&VEFNME.CNSETO.BID'
        heavto = '&&VEFNME.HEAVTO.BID'
        loncha = '&&VEFNME.LONCHA.BID'
        basloc = '&&VEFNME.BASLOC.BID'
        pmilto = '&&VEFNME.PMILTO.BID'
        lsn = '&&VEFNME.LNNO.BID'
        lst = '&&VEFNME.LTNO.BID'
        stano = '&&VEFNME.STNO.BID'
        fissno = '&&VEFNME.FISSNO.BID'
        hea_no = '&&VEFNME.HEA_NO.BID'
    endif
!
    lpain(20) = 'PPINTTO'
    lchin(20) = pintto
    lpain(21) = 'PCNSETO'
    lchin(21) = cnseto
    lpain(22) = 'PHEAVTO'
    lchin(22) = heavto
    lpain(23) = 'PLONCHA'
    lchin(23) = loncha
    lpain(24) = 'PBASLOR'
    lchin(24) = basloc
    lpain(25) = 'PLSN'
    lchin(25) = lsn
    lpain(26) = 'PLST'
    lchin(26) = lst
    lpain(27) = 'PSTANO'
    lchin(27) = stano
    lpain(28) = 'PCINFDI'
    lchin(28) = chcara(15)
    lpain(29) = 'PPMILTO'
    lchin(29) = pmilto
    lpain(30) = 'PFISNO'
    lchin(30) = fissno
    lpain(31) = 'PSTRXMR'
    lchin(31) = strx
    lpain(32) = 'PHEA_NO'
    lchin(32) = hea_no
!
! --- CREATION DES LISTES DES CHAMPS OUT
!
    lpaout(1) = 'PVECTUR'
    call gcnco2(newnom)
    lchout(1) = vect_elem(1:8)//newnom
    call corich('E', lchout(1), -1, ibid)
!
! --- PREPARATION DU VECT_ELEM RESULTAT
!
    call detrsd('VECT_ELEM', vect_elem)
    call memare(base, vect_elem, model, ' ', cara_elem,&
                'CHAR_MECA')
!
! - APPEL A CALCUL
!
    call calcul('S', option, ligrel_local, nbin, lchin,&
                lpain, nbout, lchout, lpaout, base,&
                'OUI')
    call reajre(vect_elem, lchout(1), base)
    vect_elem_ = vect_elem//'.RELR'
!
    call detrsd('CHAMP_GD', chharm)
    call detrsd('CHAMP_GD', tpsmoi)
    call detrsd('CHAMP_GD', tpsplu)
!
    call jedema()
end subroutine
