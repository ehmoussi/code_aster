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
!
subroutine cfcrma(neqmat, noma, resoco)
!
implicit none
!
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/jecrec.h"
#include "asterfort/jecroc.h"
#include "asterfort/jedema.h"
#include "asterfort/jeecra.h"
#include "asterfort/jemarq.h"
#include "asterfort/jevtbl.h"
#include "asterfort/jexnum.h"
#include "asterfort/utmess.h"
#include "asterfort/wkvect.h"
!
integer :: neqmat
character(len=8) :: noma
character(len=24) :: resoco
!
! ----------------------------------------------------------------------
!
! ROUTINE CONTACT (METHODE DISCRETE - CREATION SD)
!
! CREATION DE LA MATRICE DE "CONTACT"
! CETTE MATRICE EST STOCKEE EN LIGNE DE CIEL
! TRIANGULAIRE SYMETRIQUE PLEINE
!
! ----------------------------------------------------------------------
!
!
! IN  NOMA   : NOM DU MAILLAGE
! IN  NEQMAT : NOMBRE D'EQUATIONS DE LA MATRICE DE CONTACT
! IN  RESOCO : SD DE TRAITEMENT NUMERIQUE DU CONTACT
!
!
!

    integer :: vali(3)
    real(kind=8) :: tmax, tvala, tvmax, tv
    integer :: itbloc, hmax, ivala, ntblc, nblc, nbcol, tbmax
    character(len=19) :: stoc, macont
    integer :: ieq, icol, icompt, iblc
    integer :: jschc, jscdi, jscbl, jscib, jscde
    integer :: jrefa, jlime
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
! --- TAILLE MAXI D'UN BLOC
!
    tmax = jevtbl('TAILLE_BLOC')
    itbloc = nint(tmax*1024)
!
! --- TAUX DE VIDE MAXI D'UN BLOC POUR ALARME
!
    tvala = 0.25d0
!
! --- HAUTEUR MAXI D'UNE COLONNE
!
    hmax = neqmat
!
! --- OBJET NUME_DDL
!
    stoc = resoco(1:14)//'.SLCS'
!
! --- OBJET MATR_ASSE DE CONTACT DUALISEE ACM1AT
!
    macont = resoco(1:14)//'.MATC'
!
! --- CREATION .SCHC
!
    call wkvect(stoc(1:19)//'.SCHC', 'V V I', neqmat, jschc)
    do ieq = 1, neqmat
        zi(jschc+ieq-1) = ieq
    end do
!
! --- CREATION .SCDI
!
    call wkvect(stoc(1:19)//'.SCDI', 'V V I', neqmat, jscdi)
    do ieq = 1, neqmat
        zi(jscdi+ieq-1) = ieq*(ieq+1)/2
    end do
!
! --- LA TAILLE DE BLOC DOIT ETRE SUPERIEURE A HMAX
! --- POUR CONTENIR AU MOINS LA DERNIERE COLONNE
!
    if (hmax .gt. itbloc) then
        vali(1) = itbloc
        vali(2) = hmax
        vali(3) = hmax/1024+1
        call utmess('F', 'CONTACT_17', ni=3, vali=vali)
    endif
!
! --- ON FAIT LA PREMIERE COLONNE (DU 1ER BLOC) A PART
!
    zi(jscdi) = zi(jschc)
!
! --- HAUTEUR COLONNE CUMULEE
!
    ntblc = zi(jschc)
!
! --- NOMBRE DE BLOCS
!
    nblc = 1
!
! --- NOMBRE DE BLOCS TROP VIDES
!
    ivala = 0
!
! --- TAUX DE VIDE MAXI
!
    tvmax = 0.d0
!
! --- TAILLE MAXI D'UN BLOC
!
    tbmax = 0
!
! --- CALCUL DU NOMBRE DE BLOCS ET MISE A JOUR DE SCDI
!
    do ieq = 2, neqmat
        ntblc = ntblc + zi(jschc+ieq-1)
        if (ntblc .le. itbloc) then
!         ON PEUT TOUJOURS AJOUTER LA COLONNE DANS LE BLOC
            zi(jscdi+ieq-1) = zi(jscdi+ieq-2) + zi(jschc+ieq-1)
        else
!         LA COLONNE NE PEUT PAS ENTRER DANS LE NOUVEAU BLOC
!         TAUX DE VIDE LAISSE DANS LE BLOC
            tv = (1.d0*itbloc-zi(jscdi+ieq-2))/itbloc
            if (tv .ge. tvmax) then
                tvmax = tv
            endif
            if (tv .ge. tvala) then
                ivala = ivala+1
            endif
            if (zi(jscdi+ieq-2) .ge. tbmax) then
                tbmax = zi(jscdi+ieq-2)
            endif
!         NOUVEAU BLOC
            ntblc = zi(jschc+ieq-1)
            nblc = nblc + 1
            zi(jscdi+ieq-1) = zi(jschc+ieq-1)
        endif
    end do
!
    if (zi(jscdi-1+neqmat) .ge. tbmax) then
        tbmax = zi(jscdi-1+neqmat)
    endif
!
! --- CREATION .SCBL
!
    call wkvect(stoc(1:19)//'.SCBL', 'V V I', nblc+1, jscbl)
    zi(jscbl) = 0
    iblc = 1
    ntblc = zi(jschc)
!
    do ieq = 2, neqmat
        ntblc = ntblc + zi(jschc+ieq-1)
        if (ntblc .gt. itbloc) then
            ntblc = zi(jschc+ieq-1)
            zi(jscbl+iblc) = ieq - 1
            iblc = iblc + 1
        endif
    end do
    ASSERT(iblc.eq.nblc)
    zi(jscbl+nblc) = neqmat
!
! --- CREATION .SCIB
!
    call wkvect(stoc(1:19)//'.SCIB', 'V V I', neqmat, jscib)
    icompt = 0
    do iblc = 1, nblc
        nbcol = zi(jscbl+iblc) - zi(jscbl+iblc-1)
        do icol = 1, nbcol
            icompt = icompt + 1
            zi(jscib-1+icompt) = iblc
        end do
    end do
    ASSERT(icompt.eq.neqmat)
!
! --- CREATION .SCDE
!
    call wkvect(stoc//'.SCDE', 'V V I', 6, jscde)
    zi(jscde-1+1) = neqmat
    zi(jscde-1+2) = itbloc
    zi(jscde-1+3) = nblc
    zi(jscde-1+4) = hmax
!
! --- ON CREE AUSSI LE STOCKAGE "MORSE" CORRESPONDANT A UNE
! --- MATRICE PLEINE
!
!
! --- CREATION .REFA
!
    call wkvect(macont(1:19)//'.REFA', 'V V K24', 20, jrefa)
    zk24(jrefa-1+11) = 'MPI_COMPLET'
    zk24(jrefa-1+1) = noma
    zk24(jrefa-1+2) = resoco(1:14)
    zk24(jrefa-1+9) = 'MS'
    zk24(jrefa-1+10) = 'NOEU'
!
! --- CREATION .LIME
!
    call wkvect(macont(1:19)//'.LIME', 'V V K24', 1, jlime)
    zk24(jlime) = ' '
!
! --- CREATION .UALF
!
    call jecrec(macont(1:19)//'.UALF', 'V V R', 'NU', 'DISPERSE', 'CONSTANT', nblc)
    call jeecra(macont(1:19)//'.UALF', 'LONMAX', ival=tbmax)
    do iblc = 1, nblc
        call jecroc(jexnum(macont(1:19)//'.UALF', iblc))
    end do
!
    call jedema()
end subroutine
