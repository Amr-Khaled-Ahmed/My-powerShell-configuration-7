from yt_dlp import YoutubeDL
import os
import sys
import logging

# Configure logging
logging.basicConfig(filename='video_downloader.log', level=logging.ERROR, format='%(asctime)s - %(levelname)s - %(message)s')

def display_menu():
    print("\n===== Video Downloader Menu =====")
    print("1. Download a video")
    print("2. Download audio-only")
    print("3. Download a playlist")
    print("4. Download subtitles")
    print("5. Batch download from a list of URLs")
    print("6. Get video information")
    print("7. Update yt-dlp")
    print("8. Exit")
    choice = input("Enter your choice (1-8): ")
    return choice

def download_video(url, output_path=".", quality="best", proxy=None, speed_limit=None):
    try:
        # Set options for yt-dlp
        ydl_opts = {
            'format': quality,  # Download the specified quality
            'outtmpl': f'{output_path}/%(title)s.%(ext)s',  # Save file with title as name
            'quiet': False,  # Show progress and info
            'writethumbnail': True,  # Download thumbnail
            'addmetadata': True,  # Add metadata
            'proxy': proxy,  # Use proxy if provided
            'ratelimit': speed_limit,  # Limit download speed (in bytes)
            'continuedl': True,  # Resume incomplete downloads
            'format_sort': ['res:1080', 'res:720', 'res:480', 'res:360'],  # Fallback order for formats
            'merge_output_format': 'mp4',  # Merge into mp4 format
        }

        # Create YoutubeDL object
        with YoutubeDL(ydl_opts) as ydl:
            # Download the video
            print(f"Downloading: {url}...")
            ydl.download([url])
            print("Download complete!")

    except Exception as e:
        logging.error(f"Error downloading video: {e}")
        print(f"An error occurred: {e}")
        print("Falling back to the best available format...")
        # Retry with the best available format
        try:
            ydl_opts['format'] = 'best'
            with YoutubeDL(ydl_opts) as ydl:
                ydl.download([url])
        except Exception as fallback_error:
            logging.error(f"Fallback error: {fallback_error}")
            print(f"Fallback failed: {fallback_error}")

def list_available_formats(url):
    try:
        # Set options for yt-dlp to list formats
        ydl_opts = {
            'quiet': True,  # Suppress output
            'listformats': True,  # List available formats
        }

        # Create YoutubeDL object
        with YoutubeDL(ydl_opts) as ydl:
            print(f"Fetching available formats for: {url}...")
            ydl.download([url])  # This will list formats and exit

    except Exception as e:
        logging.error(f"Error listing formats: {e}")
        print(f"An error occurred: {e}")

def display_quality_menu():
    print("\n===== Quality Selection Menu =====")
    print("1. Best Quality")
    print("2. 1080p")
    print("3. 720p")
    print("4. 480p")
    print("5. 360p")
    print("6. List available formats")
    choice = input("Enter your choice (1-6): ")
    quality_map = {
        "1": "best",
        "2": "1080",
        "3": "720",
        "4": "480",
        "5": "360",
        "6": "list",
    }
    return quality_map.get(choice, "best")

def download_audio(url, output_path=".", proxy=None, speed_limit=None):
    try:
        # Set options for yt-dlp (audio-only)
        ydl_opts = {
            'format': 'bestaudio/best',  # Download the best audio quality
            'outtmpl': f'{output_path}/%(title)s.%(ext)s',  # Save file with title as name
            'quiet': False,  # Show progress and info
            'writethumbnail': True,  # Download thumbnail
            'addmetadata': True,  # Add metadata
            'proxy': proxy,  # Use proxy if provided
            'ratelimit': speed_limit,  # Limit download speed (in bytes)
            'continuedl': True,  # Resume incomplete downloads
            'postprocessors': [
                {
                    'key': 'FFmpegExtractAudio',  # Extract audio
                    'preferredcodec': 'mp3',  # Convert to MP3
                    'preferredquality': '192',  # Audio quality
                },
                {
                    'key': 'FFmpegMetadata',  # Add metadata
                },
                {
                    'key': 'EmbedThumbnail',  # Embed thumbnail
                },
            ],
        }

        # Create YoutubeDL object
        with YoutubeDL(ydl_opts) as ydl:
            # Download the audio
            print(f"Downloading audio: {url}...")
            ydl.download([url])
            print("Download complete!")

    except Exception as e:
        logging.error(f"Error downloading audio: {e}")
        print(f"An error occurred: {e}")

def download_playlist(url, output_path=".", proxy=None, speed_limit=None):
    try:
        # Set options for yt-dlp (playlist)
        ydl_opts = {
            'format': 'best',  # Download the best quality
            'outtmpl': f'{output_path}/%(playlist_index)s - %(title)s.%(ext)s',  # Save files with playlist index
            'quiet': False,  # Show progress and info
            'writethumbnail': True,  # Download thumbnail
            'addmetadata': True,  # Add metadata
            'proxy': proxy,  # Use proxy if provided
            'ratelimit': speed_limit,  # Limit download speed (in bytes)
            'continuedl': True,  # Resume incomplete downloads
        }

        # Create YoutubeDL object
        with YoutubeDL(ydl_opts) as ydl:
            # Download the playlist
            print(f"Downloading playlist: {url}...")
            ydl.download([url])
            print("Download complete!")

    except Exception as e:
        logging.error(f"Error downloading playlist: {e}")
        print(f"An error occurred: {e}")

def download_subtitles(url, output_path=".", languages=['en']):
    try:
        # Set options for yt-dlp (subtitles)
        ydl_opts = {
            'writesubtitles': True,  # Download subtitles
            'subtitleslangs': languages,  # Specify subtitle languages
            'outtmpl': f'{output_path}/%(title)s.%(ext)s',  # Save file with title as name
            'quiet': False,  # Show progress and info
        }

        # Create YoutubeDL object
        with YoutubeDL(ydl_opts) as ydl:
            # Download the subtitles
            print(f"Downloading subtitles for: {url}...")
            ydl.download([url])
            print("Download complete!")

    except Exception as e:
        logging.error(f"Error downloading subtitles: {e}")
        print(f"An error occurred: {e}")

def batch_download(urls, output_path=".", quality="best", proxy=None, speed_limit=None):
    for url in urls:
        download_video(url, output_path, quality, proxy, speed_limit)

def get_video_info(url):
    try:
        # Set options for yt-dlp (info only)
        ydl_opts = {
            'quiet': True,  # Suppress output
        }

        # Create YoutubeDL object
        with YoutubeDL(ydl_opts) as ydl:
            # Get video info
            info = ydl.extract_info(url, download=False)
            print("\n===== Video Information =====")
            print(f"Title: {info['title']}")
            print(f"Duration: {info['duration']} seconds")
            print(f"Resolution: {info['resolution']}")
            print(f"Uploader: {info['uploader']}")
            print(f"View Count: {info['view_count']}")
            print(f"URL: {info['webpage_url']}")

    except Exception as e:
        logging.error(f"Error fetching video info: {e}")
        print(f"An error occurred: {e}")

def update_yt_dlp():
    try:
        print("Checking for updates...")
        os.system("pip install --upgrade yt-dlp")
        print("yt-dlp updated successfully!")
    except Exception as e:
        logging.error(f"Error updating yt-dlp: {e}")
        print(f"An error occurred: {e}")

def main():
    while True:
        choice = display_menu()

        if choice == "1":
            url = input("Enter the video URL: ")
            output_path = input("Enter the output directory (leave blank for current directory): ")
            quality_choice = display_quality_menu()
            if quality_choice == "list":
                list_available_formats(url)
            else:
                quality = f"bestvideo[height<={quality_choice}]+bestaudio/best[height<={quality_choice}]"
                proxy = input("Enter proxy (leave blank if none): ") or None
                speed_limit = input("Enter download speed limit in bytes (leave blank if none): ") or None
                download_video(url, output_path if output_path else ".", quality, proxy, speed_limit)

        elif choice == "2":
            url = input("Enter the video URL: ")
            output_path = input("Enter the output directory (leave blank for current directory): ")
            proxy = input("Enter proxy (leave blank if none): ") or None
            speed_limit = input("Enter download speed limit in bytes (leave blank if none): ") or None
            download_audio(url, output_path if output_path else ".", proxy, speed_limit)

        elif choice == "3":
            url = input("Enter the playlist URL: ")
            output_path = input("Enter the output directory (leave blank for current directory): ")
            proxy = input("Enter proxy (leave blank if none): ") or None
            speed_limit = input("Enter download speed limit in bytes (leave blank if none): ") or None
            download_playlist(url, output_path if output_path else ".", proxy, speed_limit)

        elif choice == "4":
            url = input("Enter the video URL: ")
            output_path = input("Enter the output directory (leave blank for current directory): ")
            languages = input("Enter subtitle languages (comma-separated, e.g., 'en,es'): ").split(',')
            download_subtitles(url, output_path if output_path else ".", languages)

        elif choice == "5":
            urls = input("Enter video URLs (comma-separated): ").split(',')
            output_path = input("Enter the output directory (leave blank for current directory): ")
            quality_choice = display_quality_menu()
            if quality_choice == "list":
                for url in urls:
                    list_available_formats(url)
            else:
                quality = f"bestvideo[height<={quality_choice}]+bestaudio/best[height<={quality_choice}]"
                proxy = input("Enter proxy (leave blank if none): ") or None
                speed_limit = input("Enter download speed limit in bytes (leave blank if none): ") or None
                batch_download(urls, output_path if output_path else ".", quality, proxy, speed_limit)

        elif choice == "6":
            url = input("Enter the video URL: ")
            get_video_info(url)

        elif choice == "7":
            update_yt_dlp()

        elif choice == "8":
            print("Exiting the program. Goodbye!")
            break

        else:
            print("Invalid choice. Please try again.")

if __name__ == "__main__":
    main()
