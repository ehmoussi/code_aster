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
! aslint: disable=W1504
!
subroutine irecri(resultName, form, fileUnit, titre, &
                  nbcham, cham,  paraNb, paraName,&
                  storeNb, storeIndx, lresu, motfac, iocc,&
                  tablFormat, lcor, nbnot, numnoe,&
                  nbmat, nummai, nbcmp, nomcmp, lsup,&
                  borsup, linf, borinf, lmax, lmin,&
                  formr, niv)
!
implicit none
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/codent.h"
#include "asterfort/dismoi.h"
#include "asterfort/irch19.h"
#include "asterfort/irpara.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jeexin.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jerecu.h"
#include "asterfort/jeveuo.h"
#include "asterfort/rsexch.h"
#include "asterfort/rsutrg.h"
#include "asterfort/titre2.h"
#include "asterfort/utmess.h"
#include "asterfort/wkvect.h"
!
character(len=*), intent(in) :: resultName
integer, intent(in) :: fileUnit
integer, intent(in) :: storeNb, storeIndx(*)
integer, intent(in) :: paraNb
character(len=*), intent(in) :: paraName(*)
character(len=1), intent(in) :: tablFormat
character(len=*) :: form, titre, cham(*)
character(len=*) :: motfac
character(len=*) :: nomcmp(*), formr
real(kind=8) :: borsup, borinf
integer :: nbcham, niv
integer :: nbcmp, iocc
integer :: nbnot, numnoe(*), nbmat, nummai(*)
aster_logical :: lresu, lcor
aster_logical :: lsup, linf, lmax, lmin
!
! --------------------------------------------------------------------------------------------------
!
! Results management
!
! Print results datastructure in a file - Format IDEAS / RESULTAT
!
! --------------------------------------------------------------------------------------------------
!
! In  resultName       : name of results datastructure
! In  fileUnit         : index of file (logical unit)
! In  storeNb          : number of storage slots in result
! In  storeIndx        : list of storage slots in result
! In  paraNb           : number of parameters
! In  paraName         : name of parameters
! In  tablFormat       : format of file (FORM_TABL keyord)
!                         'L' => list
!                         'T' => table
!                         'E' => excel
! IN  FORM   : K8  : FORMAT D'ECRITURE
! IN  TITRE  : K80 : TITRE POUR ALI_BABA ET SUPERTAB
! IN  NBCHAM : I   : NOMBRE DE CHAMP DANS LE TABLEAU CHAM
! IN  CHAM   : K16 : NOM DES CHAMPS A IMPRIMER ( EX 'DEPL', ....
! IN  PARTIE : K4  : IMPRESSION DE LA PARTIE COMPLEXE OU REELLE DU CHAMP
! IN  LRESU  : L   : INDIQUE SI NOMCON EST UN CHAMP OU UN RESULTAT
! IN  MOTFAC : K   : NOM DU MOT CLE FACTEUR
! IN  IOCC   : I   : NUMERO D'OCCURENCE DU MOT CLE FACTEUR
! IN  MODELE : K   : NOM DU MODELE
! IN  LCOR   : L   : INDIQUE SI IMPRESSION DES COORDONNEES DES NOEUDS
!                    .TRUE.  IMPRESSION
! IN  TYCHA  : K8  : TYPE DE CHAMP (SCALAIRE,VECT_2D,VECT_3D,TENS_2D,
!                    TENS_3D) POUR LE FORMAT GMSH (VERSION >= 1.2)
! IN  NBNOT  : I   : NOMBRE DE NOEUDS A IMPRIMER
! IN  NUMNOE : I   : NUMEROS DES NOEUDS A IMPRIMER
! IN  NBMAT  : I   : NOMBRE DE MAILLES A IMPRIMER
! IN  NUMMAI : I   : NUMEROS DES MAILLES A IMPRIMER
! IN  NBCMP  : I   : NOMBRE DE COMPOSANTES A IMPRIMER
! IN  NOMCMP : K8  : NOMS DES COMPOSANTES A IMPRIMER
! IN  LSUP   : L   : =.TRUE. INDIQUE PRESENCE D'UNE BORNE SUPERIEURE
! IN  BORSUP : R   : VALEUR DE LA BORNE SUPERIEURE
! IN  LINF   : L   : =.TRUE. INDIQUE PRESENCE D'UNE BORNE INFERIEURE
! IN  BORINF : R   : VALEUR DE LA BORNE INFERIEURE
! IN  LMAX   : L   : =.TRUE. INDIQUE IMPRESSION VALEUR MAXIMALE
! IN  LMIN   : L   : =.TRUE. INDIQUE IMPRESSION VALEUR MINIMALE
! IN  FORMR  : K   : FORMAT D'ECRITURE DES REELS SUR "RESULTAT"
! IN  VERSIO : I   : NIVEAU VERSION GMSH 1 OU 2
! IN  NIV    : I   : NIVEAU IMPRESSION MOT CLE INFO
!
! --------------------------------------------------------------------------------------------------
!
    character(len=6) :: chnumo
    character(len=19) :: noch19
    character(len=24) :: nomst
    aster_logical :: lordr
    integer :: ibid, i, isy, iStore
    integer :: iret
    integer :: jtitr
    integer :: nbtitr
!
! --------------------------------------------------------------------------------------------------
!
    nomst = '&&IRECRI.SOUS_TITRE.TITR'
!
! - Print list of parameters in a file
!
    if (niv .gt. 1) then
        if (form .eq. 'RESULTAT') then
            call irpara(resultName, fileUnit ,&
                        storeNb   , storeIndx,&
                        paraNb    , paraName ,&
                        tablFormat)
        endif
    endif
!
!     *******************************************
!     --- BOUCLE SUR LA LISTE DES NUMEROS D'ORDRE
!     *******************************************
!
    do iStore = 1, storeNb
        call jemarq()
        call jerecu('V')
!
!       --- SI VARIABLE DE TYPE RESULTAT = RESULTAT COMPOSE :
!           VERIFICATION CORRESPONDANCE ENTRE NUMERO D'ORDRE
!           UTILISATEUR ORDR(IORDR) ET NUMERO DE RANGEMENT IRET
! AU CAS OU ON NE PASSE PAS EN DESSOUS ON INITIALISE LORDR A FALSE
        lordr=.false.
        if (lresu) then
            call rsutrg(resultName, storeIndx(iStore), iret, ibid)
            if (iret .eq. 0) then
!           - MESSAGE NUMERO D'ORDRE NON LICITE
                call codent(storeIndx(iStore), 'G', chnumo)
                call utmess('A', 'PREPOST2_46', sk=chnumo)
                goto 22
            endif
            lordr=.true.
        endif
!
!       --- BOUCLE SUR LE NOMBRE DE CHAMPS A IMPRIMER
        if (nbcham .ne. 0) then
            do isy = 1, nbcham
                if (lresu) then
!           * RESULTAT COMPOSE
!             - VERIFICATION EXISTENCE DANS LA SD RESULTAT NOMCON
!               DU CHAMP CHAM(ISY) POUR LE NO. D'ORDRE ORDR(IORDR)
!               ET RECUPERATION DANS NOCH19 DU NOM SE LE CHAM_GD EXISTE
                    call rsexch(' ', resultName, cham(isy), storeIndx(iStore), noch19,&
                                iret)
                    if (iret .ne. 0) goto 20
                else
!           * CHAM_GD
                    noch19 = resultName
                endif
!
!           * IMPRESSION DES PARAMETRES (FORMAT 'RESULTAT')
                if (lordr .and. form .eq. 'RESULTAT') then
!             - SEPARATION DES DIVERS NUMEROS D'ORDRE PUIS IMPRESSION
                    write(fileUnit,'(/,1X,A)') '======>'
                    call irpara(resultName, fileUnit,&
                                1, storeIndx(iStore),&
                                paraNb, paraName,&
                                tablFormat)
                    lordr=.false.
                endif
!           * CREATION D'UN SOUS-TITRE
                if (form .eq. 'RESULTAT' .or. form .eq. 'IDEAS') then
                    if (lresu) then
                        call titre2(resultName, noch19, nomst, motfac, iocc,&
                                    formr, cham(isy), storeIndx(iStore))
                    else
                        call titre2(resultName, noch19, nomst, motfac, iocc,&
                                    formr)
                    endif
                endif
!
!           * IMPRESSION DU SOUS-TITRE SI FORMAT 'RESULTAT'
                if (form .eq. 'RESULTAT') then
!              ---- SEPARATION DES DIVERS CHAMPS -----
                    write(fileUnit,'(/,1X,A)') '------>'
                    call jeveuo(nomst, 'L', jtitr)
                    call jelira(nomst, 'LONMAX', nbtitr)
                    write(fileUnit,'(1X,A)') (zk80(jtitr+i-1),i=1,&
                    nbtitr)
                endif
!
!           ********************************************************
!           * IMPRESSION DU CHAMP (CHAM_NO OU CHAM_ELEM) AU FORMAT
!             'RESULTAT' OU 'SUPERTAB'
!                LE CHAMP EST UN CHAM_GD SIMPLE SI LRESU=.FALSE. OU
!                LE CHAMP EST LE CHAM_GD CHAM(ISY) DE NUMERO D'ORDRE
!                ORDR(IORDR) ISSU DE LA SD_RESULTAT NOMCON
                call irch19(noch19, form, fileUnit, titre,&
                            resultName, cham(isy), storeIndx(iStore), lcor, nbnot,&
                            numnoe, nbmat, nummai, nbcmp, nomcmp,&
                            lsup, borsup, linf, borinf, lmax,&
                            lmin, lresu, formr)
20                 continue
            end do
        endif
22      continue
        call jedema()
    end do
!
! - Clean
!
    call jedetr('&&IRECRI.CHPRES')
    call jedetr('&&IRECRI.FVIDAV')
    call jedetr('&&IRECRI.FVIDAP')
    call jedetr('&&IRECRI.NOM_ACC')
    call jedetr('&&IRECRI.TABLE.TOT')
    call jedetr(nomst)
!
end subroutine
