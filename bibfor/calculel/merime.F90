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

subroutine merime(modelz, nchar, lchar, mater, mateco, carelz,&
                  time, compoz, matelz, nh,&
                  basz)
!
!                          DE MERIME...  PROSPER YOUP-LA-BOUM!
!
    implicit none
#include "asterf_types.h"
#include "jeveux.h"
#include "asterc/getres.h"
#include "asterfort/assert.h"
#include "asterfort/calcul.h"
#include "asterfort/codent.h"
#include "asterfort/detrsd.h"
#include "asterfort/exixfe.h"
#include "asterfort/inical.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jeexin.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/mecact.h"
#include "asterfort/mecham.h"
#include "asterfort/memare.h"
#include "asterfort/reajre.h"
#include "asterfort/redetr.h"
#include "asterfort/vrcins.h"
#include "asterfort/getvtx.h"
    integer :: nchar, nh
    character(len=*) :: modelz, carelz, matelz
    character(len=*) :: lchar(*), mateco, basz, compoz
    real(kind=8), intent(in) :: time
    character(len=*), intent(in) :: mater
!
! ----------------------------------------------------------------------
!
! CALCUL DES MATRICES ELEMENTAIRES DE RIGIDITE MECANIQUE
!
! ----------------------------------------------------------------------
!
! IN  MODELE : NOM DU MODELE
! IN  NCHAR  : NOMBRE DE CHARGES
! IN  LCHAR  : LISTE DES CHARGES
! IN  MATECO : CARTE DE MATERIAU CODE
! IN  MATER  : CHAMP MATERIAU
! IN  CARELE : CHAMP DE CARAC_ELEM
! IN  MATELZ : NOM DU MATR_ELEM RESULTAT
! IN  TIME   : INSTANT DE CALCUL
! IN  NH     : NUMERO D'HARMONIQUE DE FOURIER
! IN  BASE   : NOM DE LA BASE
! IN  COMPOR : COMPOR POUR LES MULTIFIBRE (POU_D_EM)
!
! ----------------------------------------------------------------------
!
    integer :: nbout, nbin, nbval
    parameter    (nbout=2, nbin=32)
    character(len=8) :: lpaout(nbout), lpain(nbin)
    character(len=19) :: lchout(nbout), lchin(nbin)
!
    character(len=3) :: tout
    character(len=2) :: codret
    character(len=8) :: k8bid
    character(len=16) :: option, k16bid, nomcmd
    character(len=19) :: chvarc, compor
    character(len=19) :: pintto, cnseto, heavto, loncha, basloc, lsn, lst, stano
    character(len=19) :: pmilto, fissno, pinter, pheavn
    character(len=24) :: chgeom, chcara(18), chharm
    character(len=24) :: argu, chtime
    character(len=8) :: modele, carele
    character(len=19) :: matele, ligrmo, ligrch
    character(len=1) :: base
    integer :: icha, icode, ilires, iret
    aster_logical :: lxfem
    character(len=24), pointer :: rerr(:) => null()
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
! --- INITIALISATIONS
!
    modele = modelz
    ASSERT(modele.ne.' ')
    carele = carelz
    matele = matelz
    compor = compoz
    base = basz
    chvarc = '&&MERIME.CH_VARC_R'
    chtime = '&&MERIME.CHAMP_INST'
    call getres(k8bid, k16bid, nomcmd)
    ligrmo = modele//'.MODELE'
    option = 'RIGI_MECA'
    call exixfe(modele, iret)
    lxfem = iret.ne.0
!
! --- INITIALISATION DES CHAMPS POUR CALCUL
!
    call inical(nbin, lpain, lchin, nbout, lpaout,&
                lchout)
!
! --- CHAMPS DE BASE
!
    call mecham(option, modele, carele, nh, chgeom,&
                chcara, chharm, icode)
!
! --- CHAMP TEMPS
!
    call mecact('V', chtime, 'MODELE', ligrmo, 'INST_R',&
                ncmp=1, nomcmp='INST', sr=time)
!
! --- CHAMP DES VARIABLES DE COMMANDE
!
    if (nomcmd .eq. 'MECA_STATIQUE' .or. nomcmd .eq. 'CALC_MATR_ELEM') then
        call vrcins(modele, mater, carele, time, chvarc,&
                    codret)
    endif
!
! --- PREPARATION DES MATRICES ELEMENTAIRES
!
    call memare(base, matele, modele, mater, carele,&
                option)
!     SI LA RIGIDITE EST CALCULEE SUR LE MODELE, ON ACTIVE LES S_STRUC:
    call jeveuo(matele//'.RERR', 'E', vk24=rerr)
    rerr(3) (1:3) = 'OUI'
!
    call jeexin(matele//'.RELR', iret)
    if (iret .gt. 0) call jedetr(matele//'.RELR')
!
! --- CHAMPS DE SORTIE
!
    lpaout(1) = 'PMATUUR'
    lchout(1) = matele(1:8)//'.ME001'
    lpaout(2) = 'PMATUNS'
    lchout(2) = matele(1:8)//'.ME002'
!
! --- CHAMPS POUR XFEM
!
    ilires = 0
    if (lxfem) then
        ilires = ilires+1
        pintto = modele(1:8)//'.TOPOSE.PIN'
        cnseto = modele(1:8)//'.TOPOSE.CNS'
        heavto = modele(1:8)//'.TOPOSE.HEA'
        loncha = modele(1:8)//'.TOPOSE.LON'
        pmilto = modele(1:8)//'.TOPOSE.PMI'
        basloc = modele(1:8)//'.BASLOC'
        lsn = modele(1:8)//'.LNNO'
        lst = modele(1:8)//'.LTNO'
        stano = modele(1:8)//'.STNO'
        fissno = modele(1:8)//'.FISSNO'
        pinter = modele(1:8)//'.TOPOFAC.OE'
        pheavn = modele(1:8)//'.TOPONO.HNO'
    else
        pintto = '&&MERIME.PINTTO.BID'
        cnseto = '&&MERIME.CNSETO.BID'
        heavto = '&&MERIME.HEAVTO.BID'
        loncha = '&&MERIME.LONCHA.BID'
        basloc = '&&MERIME.BASLOC.BID'
        pmilto = '&&MERIME.PMILTO.BID'
        lsn = '&&MERIME.LNNO.BID'
        lst = '&&MERIME.LTNO.BID'
        stano = '&&MERIME.STNO.BID'
        fissno = '&&MERIME.FISSNO.BID'
        pinter = '&&MERIME.PINTER.BID'
    endif
!
! --- MATRICES DE RIGIDITE
!
    tout = 'OUI'
    if (nomcmd .eq. 'CALC_MATR_ELEM') then
        call getvtx(' ', 'CALC_ELEM_MODELE', scal=tout, nbret=nbval)
    endif
    if (tout .eq. 'OUI') then
      if ((lxfem) .or. ((.not.lxfem).and.(icode.eq.0))) then
        lpain(1) = 'PGEOMER'
        lchin(1) = chgeom(1:19)
        lpain(2) = 'PMATERC'
        lchin(2) = mateco(1:19)
        lpain(3) = 'PCAORIE'
        lchin(3) = chcara(1)(1:19)
        lpain(4) = 'PCADISK'
        lchin(4) = chcara(2)(1:19)
        lpain(5) = 'PCAGNPO'
        lchin(5) = chcara(6)(1:19)
        lpain(6) = 'PCACOQU'
        lchin(6) = chcara(7)(1:19)
        lpain(7) = 'PCASECT'
        lchin(7) = chcara(8)(1:19)
        lpain(8) = 'PCAARPO'
        lchin(8) = chcara(9)(1:19)
        lpain(9) = 'PHARMON'
        lchin(9) = chharm(1:19)
        lpain(10) = 'PGEOME2'
        lchin(10) = chgeom(1:19)
        lpain(11) = 'PCAGNBA'
        lchin(11) = chcara(11)(1:19)
        lpain(12) = 'PCAMASS'
        lchin(12) = chcara(12)(1:19)
        lpain(13) = 'PCAPOUF'
        lchin(13) = chcara(13)(1:19)
        lpain(14) = 'PCAGEPO'
        lchin(14) = chcara(5)(1:19)
        lpain(15) = 'PVARCPR'
        lchin(15) = chvarc(1:19)
        lpain(16) = 'PTEMPSR'
        lchin(16) = chtime(1:19)
        lpain(17) = 'PNBSP_I'
        lchin(17) = chcara(16)(1:19)
        lpain(18) = 'PFIBRES'
        lchin(18) = chcara(17)(1:19)
        lpain(19) = 'PCOMPOR'
        lchin(19) = compor
        lpain(20) = 'PCINFDI'
        lchin(20) = chcara(15)(1:19)
        lpain(21) = 'PPINTTO'
        lchin(21) = pintto(1:19)
        lpain(22) = 'PHEAVTO'
        lchin(22) = heavto(1:19)
        lpain(23) = 'PLONCHA'
        lchin(23) = loncha(1:19)
        lpain(24) = 'PCNSETO'
        lchin(24) = cnseto(1:19)
        lpain(25) = 'PBASLOR'
        lchin(25) = basloc(1:19)
        lpain(26) = 'PLSN'
        lchin(26) = lsn(1:19)
        lpain(27) = 'PLST'
        lchin(27) = lst(1:19)
        lpain(28) = 'PSTANO'
        lchin(28) = stano(1:19)
        lpain(29) = 'PPMILTO'
        lchin(29) = pmilto(1:19)
        lpain(30) = 'PFISNO'
        lchin(30) = fissno(1:19)
        lpain(31) = 'PPINTER'
        lchin(31) = pinter(1:19)
        lpain(32) = 'PHEA_NO'
        lchin(32) = pheavn(1:19)
        call calcul('S', option, ligrmo, nbin, lchin,&
                    lpain, nbout, lchout, lpaout, base,&
                    'OUI')
        call reajre(matele, lchout(1), base)
        call reajre(matele, lchout(2), base)
        ilires = ilires + 2
      endif
    endif
!
! --- MATRICE DIRICHLET
!
    option = 'MECA_DDLM_R'
    do icha = 1, nchar
        ligrch = lchar(icha) (1:8)//'.CHME.LIGRE'
        argu = lchar(icha) (1:8)//'.CHME.LIGRE.LIEL'
        call jeexin(argu, iret)
        if (iret .le. 0) cycle
        lchin(1) = lchar(icha) (1:8)//'.CHME.CMULT'
        argu = lchar(icha) (1:8)//'.CHME.CMULT.DESC'
        call jeexin(argu, iret)
        if (iret .le. 0) cycle
        lpain(1) = 'PDDLMUR'
        ilires=ilires+1
        call codent(ilires, 'D0', lchout(1) (12:14))
        option = 'MECA_DDLM_R'
        call calcul('S', option, ligrch, 1, lchin,&
                    lpain, 1, lchout, lpaout, base,&
                    'OUI')
        call reajre(matele, lchout(1), base)
    end do
!
! --- DESTRUCTION DES RESUELEM NULS
!
    call redetr(matele)
    call detrsd('CHAMP_GD', chtime)
!
    call jedema()
end subroutine
