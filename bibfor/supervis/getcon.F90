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

subroutine getcon(nomres, iob, ishf, ilng, ctype,&
                  lcon, iadvar, nomob)
! aslint: disable=
    implicit none
#include "jeveux.h"
!
#include "asterfort/assert.h"
#include "asterfort/jedetr.h"
#include "asterfort/jeexin.h"
#include "asterfort/jelira.h"
#include "asterfort/jenuno.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnum.h"
#include "asterfort/jjvern.h"
#include "asterfort/lxlgut.h"
#include "asterfort/wkvect.h"
    character(len=*) :: nomres
    integer :: ctype, lcon, iob, ishf, ilng
    integer :: iadvar, loc
    character(len=24) :: nomob
! IN  NOMRES  K*  NOM DU CONCEPT DEMANDE
! IN  IBOB    I  POUR UNE COLLECTION : NUMERO DE L OBJET
! IN  ISHF    I  POUR UN VECTEUR     : SHIFT DANS LE VECTEUR
! IN  ILNG    I  POUR UN VECTEUR     : NB DE VALEURS REQUISES APRES ISHF
! OUT CTYPE   I   LE TYPE : CTYPE (1=REEL, 2=ENTIER, 3=COMPLEXE,
!                                  4=K8,5=K16,6=K24,7=K32,8=K80, 9=I4)
!                                  0=PAS DE VALEUR, <0=ERREUR
! OUT LCON    I  LISTE DES LONGUEURS : NOMBRE DE VALEURS
! OUT IADVAR  I  LISTE DES ADRESSES DU TABLEAU
! OUT NOMOB   K* POUR UNE COLLECTION : NOM DE L OBJET SI EXISTE
!
    character(len=4) :: type
    character(len=2) :: acces
    character(len=1) :: xous, genr
    integer :: jres, iret, lobj, iad, kk
    character(len=32) :: noml32
!     ------------------------------------------------------------------
    ctype = -1
!             123456789.123456789.12
    noml32='                      '
    noml32=nomres
!     AU DELA DE 24 : RESERVE JEVEUX &&xxxx
    ASSERT(lxlgut(noml32).le.24)
    call jjvern(noml32, 0, iret)
    if (iret .eq. 0) then
!     CET OBJET N'EXISTE PAS
        goto 999
    endif
    call jelira(noml32, 'XOUS', cval=xous)
    call jelira(noml32, 'GENR', cval=genr)
    nomob=' '
    if (xous .eq. 'X') then
!     ------------------------------------------------------------------
!     CET OBJET EST UNE COLLECTION, ON VEUT SON ELEMENT NUMERO IOB
!     ------------------------------------------------------------------
        ctype=0
        call jeexin(jexnum(noml32, iob), iret)
        if (iret .le. 0) goto 999
        call jelira(noml32, 'ACCES', cval=acces)
        if (acces .eq. 'NO') then
            call jenuno(jexnum(noml32, iob), nomob)
        endif
        call jeveuo(jexnum(noml32, iob), 'L', jres)
        call jelira(jexnum(noml32, iob), 'LONMAX', lobj)
        call jelira(jexnum(noml32, iob), 'TYPELONG', cval=type)
        lcon = lobj
        if (type .eq. 'R') then
!     LES VALEURS SONT REELLES
            ctype=1
            iadvar=loc(zr(jres))
        else if (type.eq.'I') then
!     LES VALEURS SONT ENTIERES
            ctype=2
            iadvar=loc(zi(jres))
        else if (type.eq.'IS') then
!     LES VALEURS SONT ENTIERES
            ctype=9
            iadvar=loc(zi4(jres))
        else if (type.eq.'C') then
!     LES VALEURS SONT COMPLEXES
            ctype=3
            iadvar=loc(zc(jres))
        else if (type.eq.'K8') then
!     LES VALEURS SONT DES CHAINES
            ctype=4
            iadvar=loc(zk8(jres))
        else if (type.eq.'K16') then
!     LES VALEURS SONT DES CHAINES
            ctype=5
            iadvar=loc(zk16(jres))
        else if (type.eq.'K24') then
!     LES VALEURS SONT DES CHAINES
            ctype=6
            iadvar=loc(zk24(jres))
        else if (type.eq.'K32') then
!     LES VALEURS SONT DES CHAINES
            ctype=7
            iadvar=loc(zk32(jres))
        else if (type.eq.'K80') then
!     LES VALEURS SONT DES CHAINES
            ctype=8
            iadvar=loc(zk80(jres))
        else
!     TYPE INCONNU
            ctype=0
        endif
    else if ((xous.eq.'S').and.(genr.ne.'N')) then
!     ------------------------------------------------------------------
!     CET OBJET EXISTE ET EST SIMPLE. ON PEUT AVOIR SA VALEUR
!     ------------------------------------------------------------------
        call jeveuo(noml32, 'L', jres)
        call jelira(noml32, 'LONMAX', lcon)
        if (ilng .ne. 0) lcon=ilng
        call jelira(noml32, 'TYPELONG', cval=type)
        if (type .eq. 'R') then
!     LES VALEURS SONT REELLES
            ctype=1
            iadvar=loc(zr(jres+ishf))
        else if (type.eq.'I') then
!     LES VALEURS SONT ENTIERES
            ctype=2
            iadvar=loc(zi(jres+ishf))
        else if (type.eq.'S') then
!     LES VALEURS SONT ENTIERES
            ctype=9
            iadvar=loc(zi4(jres+ishf))
        else if (type.eq.'C') then
!     LES VALEURS SONT COMPLEXES
            ctype=3
            iadvar=loc(zc(jres+ishf))
        else if (type.eq.'K8') then
!     LES VALEURS SONT DES CHAINES
            ctype=4
            iadvar=loc(zk8(jres+ishf))
        else if (type.eq.'K16') then
!     LES VALEURS SONT DES CHAINES
            ctype=5
            iadvar=loc(zk16(jres+ishf))
        else if (type.eq.'K24') then
!     LES VALEURS SONT DES CHAINES
            ctype=6
            iadvar=loc(zk24(jres+ishf))
        else if (type.eq.'K32') then
!     LES VALEURS SONT DES CHAINES
            ctype=7
            iadvar=loc(zk32(jres+ishf))
        else if (type.eq.'K80') then
!     LES VALEURS SONT DES CHAINES
            ctype=8
            iadvar=loc(zk80(jres+ishf))
        else
!     TYPE INCONNU
            ctype=0
        endif
    else if ((xous.eq.'S').and.(genr.eq.'N')) then
!     ------------------------------------------------------------------
!     CET OBJET EST SIMPLE MAIS C EST UN REPERTOIRE DE NOMS
!     ------------------------------------------------------------------
        call jelira(noml32, 'NOMMAX', lcon)
        call jelira(noml32, 'TYPELONG', cval=type)
        call jedetr('&&GETCON.PTEUR_NOM')
        call wkvect('&&GETCON.PTEUR_NOM', 'V V '//type, lcon, iad)
        if (type .eq. 'K8') then
            do 51, kk=1,lcon
            call jenuno(jexnum(noml32, kk), zk8(iad-1+kk))
51          continue
            ctype=4
            iadvar=loc(zk8(iad))
        else if (type.eq.'K16') then
            do 52, kk=1,lcon
            call jenuno(jexnum(noml32, kk), zk16(iad-1+kk))
52          continue
            ctype=5
            iadvar=loc(zk16(iad))
        else if (type.eq.'K24') then
            do 53, kk=1,lcon
            call jenuno(jexnum(noml32, kk), zk24(iad-1+kk))
53          continue
            ctype=6
            iadvar=loc(zk24(iad))
        endif
    endif
!
999  continue
end subroutine
